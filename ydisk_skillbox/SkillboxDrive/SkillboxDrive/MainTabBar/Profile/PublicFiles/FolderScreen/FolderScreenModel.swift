//
//  FolderScreenModel.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 29.11.2023.
//

import Foundation

final class FolderScreenModel {

    // MARK: - Base Model data
    var modelData = LatestFiles(items: [])

    func getDataOfPublishedFolder (publicUrl: String?, completion: @escaping () -> Void, errorHandler: @escaping () -> Void, noInternet: @escaping () -> Void) {

        guard let publicUrl = publicUrl else { return }

        let valueUrl = URLComponents(string: "\(publicUrl)")
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/public/resources")
        components?.queryItems = [URLQueryItem(name: "public_key", value: "\(String(describing: valueUrl))")]
        guard let url = components?.url else { return }
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, _, error) in
            guard let data = data else {
                print("Error: \(String(describing: error))")
                noInternet()
                return
            }
            guard let publishedFolder = try? JSONDecoder().decode(LatestFiles.self, from: data) else {
                print("Error DataFolder serialization")
                return
            }
            guard let self = self else { return }
            guard publishedFolder.items?.count != 0 else {
                errorHandler()
                return }
            self.modelData = publishedFolder
            completion()
        }
        task.resume()
    }
}
