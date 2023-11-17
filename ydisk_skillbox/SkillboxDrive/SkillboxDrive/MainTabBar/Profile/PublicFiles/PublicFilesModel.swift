//
//  PublicFilesModel.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 13.11.2023.
//

import Foundation

final class PublicFilesModel {
    
    var modelData = PublishedFiles(items: [])
    
    func getPublishedFiles(completion: @escaping () -> Void) {
        
        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return }
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources/public")
        components?.queryItems = [URLQueryItem(name: "preview_size", value: "L"), URLQueryItem(name: "preview_crop", value: "false")]

        guard let url = components?.url else { return }
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data else {
                print("Error: \(String(describing: error))")
                return }
            guard let latestFiles = try? JSONDecoder().decode(PublishedFiles.self, from: data) else {
                print("Error serialization")
                return }
            guard let self = self else { return }
            print("Received: \(latestFiles.items?.count ?? 0) files")
            self.modelData = latestFiles
            completion()
        }
        task.resume()
    }
}
