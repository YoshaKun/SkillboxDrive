//
//  NetworkServiceAllFilesProtocol.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 19.12.2023.
//

import Foundation

protocol NetworkServiceAllFilesProtocol: AnyObject {
    func getModelDataAllFiles() -> LatestFilesModel
    func getAllFiles(
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void,
        noInternet: @escaping () -> Void
    )
    func getBoolIsPaginating() -> Bool
    func additionalGetingAllFiles(
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    )
    func changePaginatingStateToFalse()
}

extension NetworkService: NetworkServiceAllFilesProtocol {
    
    // MARK: - All Files Screen - 1
    
    func getModelDataAllFiles() -> LatestFilesModel {
        let data = modelDataAllFiles
        return data
    }
    
    func getAllFiles(
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void,
        noInternet: @escaping () -> Void
    ) {
        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return }
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources")
        components?.queryItems = [
            URLQueryItem(name: "path", value: "disk:/"),
            URLQueryItem(name: "preview_size", value: "L"),
            URLQueryItem(name: "preview_crop", value: "false"),
            URLQueryItem(name: "limit", value: "10")
        ]
        guard let url = components?.url else { return }
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, _, error) in
            guard let data = data else {
                print("No internet get data: \(String(describing: error))")
                noInternet()
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let allFilesFolder = try? decoder.dashDecoding().decode(PublishedFolder.self, from: data) else {
                print("Error serialization getAllfiles")
                errorHandler()
                return
            }
            print("decoder data: \(allFilesFolder)")
            guard let self = self else { return }
            let items = allFilesFolder.embedded.items
            self.modelDataAllFiles.items = items
            completion()
        }
        task.resume()
    }
    
    func getBoolIsPaginating() -> Bool {
        return isPaginatingAllFiles
    }
    
    // Additional getting all files (Пагинация)
    func additionalGetingAllFiles (
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    ) {
        isPaginatingAllFiles = true
        guard let model = modelDataAllFiles.items else { return }
        let count = model.count
        print("modelDataAllFiles.count = \(count)")
        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return }
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources")
        components?.queryItems = [
            URLQueryItem(name: "path", value: "disk:/"),
            URLQueryItem(name: "preview_size", value: "L"),
            URLQueryItem(name: "preview_crop", value: "false"),
            URLQueryItem(name: "limit", value: "10"),
            URLQueryItem(name: "offset", value: "\(count)")
        ]
        guard let url = components?.url else {
            self.isPaginatingAllFiles = false
            return
        }
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, _, error) in
            guard let data = data else {
                print("additionalGetting - No internet: \(String(describing: error))")
                errorHandler()
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let allFilesFolder = try? decoder.dashDecoding().decode(PublishedFolder.self, from: data) else {
                print("Error serialization")
                guard let self = self else { return }
                self.isPaginatingAllFiles = false
                return
            }
            guard let self = self else { return }
            guard let items = allFilesFolder.embedded.items else {
                isPaginatingAllFiles = false
                return
            }
            self.modelDataAllFiles.items?.append(contentsOf: items)
            completion()
            isPaginatingAllFiles = false
            print("isPaging = \(isPaginatingAllFiles)")
        }
        task.resume()
    }
    
    func changePaginatingStateToFalse() {
        isPaginatingAllFiles = false
    }
}
