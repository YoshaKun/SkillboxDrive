//
//  PublicFilesModel.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 13.11.2023.
//

import Foundation

final class PublicFilesModel {
    
    var modelData = LatestFiles(items: [])
    
    func getPublishedFiles (completion: @escaping () -> Void, errorHandler: @escaping () -> Void) {
        
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
            guard let latestFiles = try? JSONDecoder().decode(LatestFiles.self, from: data) else {
                print("Error serialization")
                return }
            guard let self = self else { return }
            guard latestFiles.items?.count != 0 else { 
                errorHandler()
                return }
            print("Received: \(String(describing: latestFiles.items?.count)) files")
            self.modelData = latestFiles
            completion()
        }
        task.resume()
    }
    
    func removePublishedFile (path: String?, completion: @escaping () -> Void) {
        
        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return }
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources/unpublish")
        components?.queryItems = [URLQueryItem(name: "path", value: path)]
        guard let url = components?.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response  as? HTTPURLResponse {
                switch response.statusCode {
                case 200..<300:
                    print("Success")
                    completion()
                default:
                    print("Status: \(response.statusCode)")
                }
            }
        }
        task.resume()
    }
    
    func getDataOfPublishedFolder (publicUrl: String?, completion: @escaping () -> Void) {
        
        guard let publicUrl = publicUrl else { return }

        let valueUrl = URLComponents(string: "\(publicUrl)")
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/public/resources")
        components?.queryItems = [URLQueryItem(name: "public_key", value: "\(String(describing: valueUrl))")]
        guard let url = components?.url else { return }
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data else {
                print("Error: \(String(describing: error))")
                return
            }
            guard let publishedFolder = try? JSONDecoder().decode(LatestFiles.self, from: data) else {
                print("Error DataFolder serialization")
                return
            }
            guard let self = self else { return }
            self.modelData = publishedFolder
            completion()
        }
        task.resume()
    }
}
