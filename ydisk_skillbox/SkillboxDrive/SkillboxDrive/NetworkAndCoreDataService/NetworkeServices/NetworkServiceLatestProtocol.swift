//
//  NetworkServiceLatestProtocol.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 18.12.2023.
//

import Foundation

// MARK: - NetworkServiceLatestProtocol

protocol NetworkServiceLatestProtocol: AnyObject {
    func getLatestFiles(
        completion: @escaping () -> Void,
        noInternet: @escaping () -> Void
    )
    func getModelData() -> LatestFilesModel
    func getFileFromPathOnLatestScreen(
        path: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    )
    func additionalGetingLatestFilesOnLatestScreen(
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    )
    func isPaginatingLatestFiles() -> Bool
    func changePaginatingStateOnFalse()
}

// MARK: - extension NetworkService

extension NetworkService: NetworkServiceLatestProtocol {
    
    func getLatestFiles(
        completion: @escaping () -> Void,
        noInternet: @escaping () -> Void
    ) {
        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return }
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources/last-uploaded")
        components?.queryItems = [
            URLQueryItem(name: "preview_size", value: "L"),
            URLQueryItem(name: "preview_crop", value: "false"),
            URLQueryItem(name: "limit", value: "10")
        ]
        guard let url = components?.url else { return }
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, _, error) in
            guard let data = data else {
                print("Error: \(String(describing: error))")
                noInternet()
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let latestFiles = try? decoder.decode(LatestFilesModel.self, from: data) else {
                print("Error serialization")
                return
            }
            guard let self = self else { return }
            self.modelDataLatest = latestFiles
            completion()
        }
        task.resume()
    }
    
    func getModelData() -> LatestFilesModel {
        return modelDataLatest
    }
    
    // Get data for open files in Latest screen
    func getFileFromPathOnLatestScreen(
        path: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    ) {
        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return }
        guard let pathUrl = path else { return }
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources")
        components?.queryItems = [URLQueryItem(name: "path", value: "\(pathUrl)")]
        guard let url = components?.url else { return }
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data else {
                print("Error: \(String(describing: error))")
                return }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard (try? decoder.decode(LatestItems.self, from: data)) != nil else {
                print("Error serialization")
                errorHandler()
                return }
            completion()
        }
        task.resume()
    }
    
    // Additional getting latest files (Пагинация)
    func additionalGetingLatestFilesOnLatestScreen (
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    ) {
        isPaginatingLatest = true
        guard let model = modelDataLatest.items else { return }
        let count = model.count
        print("modelData.count = \(count)")
        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return }
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources/last-uploaded")
        components?.queryItems = [
            URLQueryItem(name: "preview_size", value: "L"),
            URLQueryItem(name: "preview_crop", value: "false"),
            URLQueryItem(name: "limit", value: "\(count + 10)")
        ]
        guard let url = components?.url else {
            self.isPaginatingLatest = false
            return
        }
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, _, _) in
            guard let data = data else {
                print("additionalGetting - No internet")
                errorHandler()
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let latestFiles = try? decoder.decode(LatestFilesModel.self, from: data) else {
                print("Error serialization")
                guard let self = self else { return }
                self.isPaginatingLatest = false
                return
            }
            guard let self = self else { return }
            guard latestFiles.items != nil else {
                isPaginatingLatest = false
                return
            }
            self.modelDataLatest = latestFiles
            completion()
            isPaginatingLatest = false
            print("isPaging = \(isPaginatingLatest)")
        }
        task.resume()
    }
    
    func isPaginatingLatestFiles() -> Bool {
        return isPaginatingLatest
    }
    
    func changePaginatingStateOnFalse() {
        isPaginatingLatest = false
    }
}
