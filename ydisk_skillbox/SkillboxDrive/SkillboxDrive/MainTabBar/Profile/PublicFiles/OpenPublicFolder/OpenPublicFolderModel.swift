//
//  PublicFilesModel.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 13.11.2023.
//

import Foundation
import RealmSwift

final class OpenPublicFolderModel {
    
    // MARK: - Pagination FLAG
    var isPaginating = false
    
    // MARK: - Base Model data
    var modelData = LatestFiles(items: [])
    
    // MARK: - Remove published
    func removePublishedFile (
        path: String?,
        completion: @escaping () -> Void,
        errorHendler: @escaping () -> Void
    ) {
        
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
                    errorHendler()
                }
            }
        }
        task.resume()
    }

    func getDataOfPublishedFolder (
        publicUrl: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void,
        noFiles: @escaping () -> Void,
        noInternet: @escaping () -> Void
    ) {
        
        guard let publicUrl = publicUrl else { return }
        print(publicUrl)

        guard let valueUrl = URLComponents(string: "\(publicUrl)") else { return }
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/public/resources")
        components?.queryItems = [
            URLQueryItem(name: "public_key", value: "\(String(describing: valueUrl))")
        ]
        guard let url = components?.url else { return }
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data else {
                print("No internet folder: \(String(describing: error))")
                noInternet()
                return
            }
            guard let publishedFolder = try? JSONDecoder().decode(PublishedFolder.self, from: data) else {
                print("Error published folder decode: \(String(describing: response))")
                errorHandler()
                return
            }
            guard let self = self else { return }
            let filesInFolder = publishedFolder._embedded
            guard let items = filesInFolder.items else { return }
            guard !items.isEmpty else {
                noFiles()
                return }
            self.modelData = filesInFolder
            completion()
        }
        task.resume()
    }
    
    // MARK: - Additional getting published files
    func additionalGettingDataOfPublishedFolder (
        publicUrl: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    ) {
        
        isPaginating = true
        guard let model = modelData.items else { return }
        let count = model.count
        print("modelData.count = \(count)")
        guard let publicUrl = publicUrl else { return }
        print(publicUrl)
        
        guard let valueUrl = URLComponents(string: "\(publicUrl)") else { return }
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/public/resources")
        components?.queryItems = [
            URLQueryItem(name: "public_key", value: "\(String(describing: valueUrl))"),
            URLQueryItem(name: "preview_size", value: "L"),
            URLQueryItem(name: "preview_crop", value: "false"),
            URLQueryItem(name: "limit", value: "10"),
            URLQueryItem(name: "offset", value: "\(count)")
        ]
        guard let url = components?.url else {
            self.isPaginating = false
            return
        }
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data else {
                print("No internet folder: \(String(describing: error))")
                errorHandler()
                return
            }
            guard let publishedFolder = try? JSONDecoder().decode(PublishedFolder.self, from: data) else {
                print("Error published folder decode: \(String(describing: response))")
                guard let self = self else { return }
                self.isPaginating = false
                errorHandler()
                return
            }
            guard let self = self else { return }
            let filesInFolder = publishedFolder._embedded
            guard let items = filesInFolder.items else { return }
            guard items.count != 0 else {
                isPaginating = false
                errorHandler()
                return
            }
            self.modelData.items?.append(contentsOf: items)
            completion()
            isPaginating = false
            print("isPaging = \(isPaginating)")
        }
        task.resume()
    }
}
