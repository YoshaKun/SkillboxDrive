//
//  NetworkServiceProfileProtocol.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 19.12.2023.
//

import Foundation

protocol NetworkServiceProfileProtocol: AnyObject {
    func updatePieChartData(
        completion: @escaping (
            _ totalSpace: Int?,
            _ usedSpace: Int?
        ) -> Void,
        errorHandler: @escaping () -> Void
    )
}

extension NetworkService: NetworkServiceProfileProtocol {

    // Update PieChart data
    func updatePieChartData(
        completion: @escaping (_ totalSpace: Int?, _ usedSpace: Int?) -> Void,
        errorHandler: @escaping () -> Void
    ) {
        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return }
        let components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk")
        guard let url = components?.url else { return }
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                print("Error: \(String(describing: error))")
                errorHandler()
                return }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let newFiles = try? decoder.decode(DiskSpaceResponse.self, from: data) else { return }
            guard let total = newFiles.totalSpace, let used = newFiles.usedSpace else { return }
            completion(total, used)
        }
        task.resume()
    }
}
