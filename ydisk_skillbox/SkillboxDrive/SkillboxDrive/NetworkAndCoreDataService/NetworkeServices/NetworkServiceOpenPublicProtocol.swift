//
//  NetworkServiceOpenPublicProtocol.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 20.12.2023.
//

import Foundation

protocol NetworkServiceOpenPublicProtocol: AnyObject {
    func gettingModelDataPublicOpen() -> LatestFilesModel
    func removePublishedData(
        path: String?,
        completion: @escaping () -> Void,
        errorHendler: @escaping () -> Void
    )
    func getDataOfOpenPublishedFolder (
        publicUrl: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void,
        noFiles: @escaping () -> Void,
        noInternet: @escaping () -> Void
    )
    func fetchPaginatingState() -> Bool
    func additionalGettingDataOfOpenPublishedFolder (
        publicUrl: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    )
    func changePaginatingOpenPublicStateToFalse()
}

extension NetworkService: NetworkServiceOpenPublicProtocol {
    
    func gettingModelDataPublicOpen() -> LatestFilesModel {
        return modelDataPublicOpen
    }
    
    func removePublishedData(path: String?, completion: @escaping () -> Void, errorHendler: @escaping () -> Void) {
        removePublishedFile(
            path: path,
            completion: completion,
            errorHendler: errorHendler
        )
    }
    
    // MARK: - Profile Screen 3
    func getDataOfOpenPublishedFolder (
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
        components?.queryItems = [URLQueryItem(name: "public_key", value: "\(String(describing: valueUrl))")]
        guard let url = components?.url else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data else {
                print("No internet folder: \(String(describing: error))")
                noInternet()
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let publishedFolder = try? decoder.dashDecoding().decode(PublishedFolder.self, from: data) else {
                print("Error published folder decode: \(String(describing: response))")
                errorHandler()
                return
            }
            guard let self = self else { return }
            let filesInFolder = publishedFolder.embedded
            guard let items = filesInFolder.items else { return }
            guard !items.isEmpty else {
                noFiles()
                return }
            self.modelDataPublicOpen = filesInFolder
            completion()
        }
        task.resume()
    }
    
    func fetchPaginatingState() -> Bool {
        return isPaginatingPublicOpen
    }
    
    // Additional getting data of published Folder (Пагинация)
    func additionalGettingDataOfOpenPublishedFolder (
        publicUrl: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    ) {
        isPaginatingPublicOpen = true
        guard let model = modelDataPublicOpen.items else { return }
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
            self.isPaginatingPublicOpen = false
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data else {
                print("No internet folder: \(String(describing: error))")
                errorHandler()
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let publishedFolder = try? decoder.dashDecoding().decode(PublishedFolder.self, from: data) else {
                print("Error published folder decode: \(String(describing: response))")
                guard let self = self else { return }
                self.isPaginatingPublicOpen = false
                errorHandler()
                return
            }
            guard let self = self else { return }
            let filesInFolder = publishedFolder.embedded
            guard let items = filesInFolder.items else { return }
            guard items.count != 0 else {
                isPaginatingPublicOpen = false
                errorHandler()
                return
            }
            self.modelDataPublicOpen.items?.append(contentsOf: items)
            completion()
            isPaginatingPublicOpen = false
            print("isPaging = \(isPaginatingPublicOpen)")
        }
        task.resume()
    }
    
    func changePaginatingOpenPublicStateToFalse() {
        isPaginatingPublicOpen = false
    }
}
