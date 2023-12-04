//
//  OpenFolderModel.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 02.12.2023.
//

import Foundation
import RealmSwift

final class OpenFolderModel {
    
    // MARK: - Base Model data
    var modelData = LatestFiles(items: [])
    
    // MARK: - Get files for tableView
    func getAllFiles(
        path: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void,
        noInternet: @escaping () -> Void
    ) {
        
        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return }
        guard let pathUrl = path else { return }
        print("\(pathUrl)")

        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources")
        components?.queryItems = [
            URLQueryItem(name: "path", value: "\(pathUrl)"),
            URLQueryItem(name: "preview_size", value: "L"),
            URLQueryItem(name: "preview_crop", value: "false")
        ]

        guard let url = components?.url else { return }
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data else {
                print("No internet get data: \(String(describing: error))")
                noInternet()
                return
            }
            guard let allFilesFolder = try? JSONDecoder().decode(PublishedFolder.self, from: data) else {
                print("Error serialization")
                errorHandler()
                return
            }
            guard let self = self else { return }
            guard let items = allFilesFolder._embedded.items else { return }
            guard !items.isEmpty else {
                errorHandler()
                return
            }
            self.modelData.items = items
            completion()
        }
        task.resume()
    }
}
