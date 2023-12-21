//
//  NetworkServiceAllOpenFolderProtocol.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 19.12.2023.
//

import Foundation

protocol NetworkServiceAllOpenFolderProtocol: AnyObject {
    func getModelDataAllFilesOpenFolder() -> LatestFiles
    func getAllFilesOpenFolder(
        path: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void,
        noInternet: @escaping () -> Void
    )
    func gettingIsPaginatingAllOpenFolder() -> Bool
    func additionalGettingAllFilesOpenFolder(
        path: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    )
    func changePaginatingStateAllOpenFolderOnFalse()
}

extension NetworkService: NetworkServiceAllOpenFolderProtocol {
    
    func getModelDataAllFilesOpenFolder() -> LatestFiles {
        return modelDataAllOpenFolder
    }
    
    func getAllFilesOpenFolder(
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
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, _, error) in
            guard let data = data else {
                print("No internet get data: \(String(describing: error))")
                noInternet()
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let allFilesFolder = try? decoder.dashDecoding().decode(PublishedFolder.self, from: data) else {
                print("Error serialization")
                errorHandler()
                return
            }
            guard let self = self else { return }
            guard let items = allFilesFolder.embedded.items else { return }
            guard !items.isEmpty else {
                errorHandler()
                return
            }
            self.modelDataAllOpenFolder.items = items
            completion()
        }
        task.resume()
    }
    
    // Pagination
    func gettingIsPaginatingAllOpenFolder() -> Bool {
        return isPaginatingAllOpenFolder
    }
    
    // Additional getting files in all files open folder
    func additionalGettingAllFilesOpenFolder(
        path: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    ) {
        isPaginatingAllOpenFolder = true
        guard let model = modelDataAllOpenFolder.items else { return }
        let count = model.count
        print("modelDataAllOpenFolder.count = \(count)")
        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return }
        guard let pathUrl = path else { return }
        print("\(pathUrl)")
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources")
        components?.queryItems = [
            URLQueryItem(name: "path", value: "\(pathUrl)"),
            URLQueryItem(name: "preview_size", value: "L"),
            URLQueryItem(name: "preview_crop", value: "false"),
            URLQueryItem(name: "limit", value: "\(count + 10)")
        ]
        guard let url = components?.url else {
            self.isPaginatingAllOpenFolder = false
            return
        }
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, _, error) in
            guard let data = data else {
                print("No internet get data: \(String(describing: error))")
                errorHandler()
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let allFilesFolder = try? decoder.dashDecoding().decode(PublishedFolder.self, from: data) else {
                print("Error serialization")
                guard let self = self else { return }
                self.isPaginatingAllOpenFolder = false
                errorHandler()
                return
            }
            guard let self = self else { return }
            guard let items = allFilesFolder.embedded.items else { return }
            guard !items.isEmpty else {
                isPaginatingAllOpenFolder = false
                errorHandler()
                return
            }
            self.modelDataAllOpenFolder.items = items
            completion()
            isPaginatingAllOpenFolder = false
            print("isPaging = \(isPaginatingAllOpenFolder)")
        }
        task.resume()
    }
    
    func changePaginatingStateAllOpenFolderOnFalse() {
        isPaginatingAllOpenFolder = false
    }
}
