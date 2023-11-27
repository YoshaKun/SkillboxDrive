//
//  LatestModel.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 16.11.2023.
//

import Foundation

final class LatestModel {
    
    var modelData = LatestFiles(items: [])
    
    func getLatestFiles(completion: @escaping () -> Void, errorHandler: @escaping () -> Void) {
        
        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return }
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources/last-uploaded")
        components?.queryItems = [URLQueryItem(name: "preview_size", value: "L"), URLQueryItem(name: "preview_crop", value: "false")]

        guard let url = components?.url else { return }
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data else {
                print("Error: \(String(describing: error))")
                errorHandler()
                return }
            guard let latestFiles = try? JSONDecoder().decode(LatestFiles.self, from: data) else {
                print("Error serialization")
                return }
            guard let self = self else { return }
            self.modelData = latestFiles
            completion()
        }
        task.resume()
    }
    
    func getFileFromPath(path: String?, completion: @escaping () -> Void, errorHandler: @escaping () -> Void) {
        
        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return }
        guard let pathUrl = path else { return }

        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources")
        components?.queryItems = [URLQueryItem(name: "path", value: "\(pathUrl)")]

        guard let url = components?.url else { return }
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data else {
                print("Error: \(String(describing: error))")
                return }
            guard let files = try? JSONDecoder().decode(LatestItems.self, from: data) else {
                print("Error serialization")
                errorHandler()
                return }
            completion()
        }
        task.resume()
    }
}
