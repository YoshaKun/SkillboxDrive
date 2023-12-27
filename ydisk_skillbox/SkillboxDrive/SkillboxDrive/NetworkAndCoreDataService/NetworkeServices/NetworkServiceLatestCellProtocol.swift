//
//  NetworkServiceLatestCellProtocol.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 18.12.2023.
//

import Foundation

protocol NetworkServiceLatestCellProtocol: AnyObject {
    func getImageForCell(
        urlStr: String,
        completion: @escaping (Data) -> Void
    )
}

extension NetworkService: NetworkServiceLatestCellProtocol {

    // MARK: - CELL
    // Public cell - getting image for cell
    func getImageForCell(
        urlStr: String,
        completion: @escaping (Data) -> Void
    ) {
        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return }
        let components = URLComponents(string: "\(urlStr)")
        guard let url = components?.url else { return }
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data else {
                AlertHelper.showAlert(withMessage: "Error: \(String(describing: error?.localizedDescription))")
                return }
            completion(data)
        }
        task.resume()
    }
}
