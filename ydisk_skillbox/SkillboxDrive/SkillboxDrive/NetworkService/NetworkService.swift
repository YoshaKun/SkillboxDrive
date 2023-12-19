//
//  NetworkService.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 12.12.2023.
//

import Foundation

class NetworkService {
    
    // MARK: - SingleTone
    static let shared = NetworkService(); private init() {}
    // Pagination FLAG
    var isPaginatingPublic = false
    var isPaginatingPublicOpen = false
    var isPaginatingLatest = false
    var isPaginatingAllFiles = false
    var isPaginatingAllOpenFolder = false
    // Public Model data
    var modelDataPublic = LatestFiles(items: [])
    var modelDataPublicOpen = LatestFiles(items: [])
    var modelDataLatest = LatestFiles(items: [])
    var modelDataAllFiles = LatestFiles(items: [])
    var modelDataAllOpenFolder = LatestFiles(items: [])

    // MARK: - Profile Screen 1
    
    
    // MARK: - Profile Screen 2 - Main List of Published Files
    // Get published files
    func getPublishedFiles (
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void,
        noInternet: @escaping () -> Void
    ) {
        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return }
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources/public")
        components?.queryItems = [URLQueryItem(name: "preview_size", value: "L"),
                                  URLQueryItem(name: "preview_crop", value: "false"),
                                  URLQueryItem(name: "limit", value: "10")
        ]
        guard let url = components?.url else { return }
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data else {
                print("No internrt: \(String(describing: error))")
                noInternet()
                return }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let latestFiles = try? decoder.decode(LatestFiles.self, from: data) else {
                print("Error serialization")
                return }
            guard let self = self else { return }
            guard latestFiles.items?.count != 0 else {
                errorHandler()
                return }
            self.modelDataPublic = latestFiles
            completion()
            print("Количество ячеек = \(self.modelDataPublic.items?.count ?? 000)")
        }
        task.resume()
    }
    
    // Additional getting published files (Пагинация)
    func additionalGetingPublishedFiles (
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    ) {
        isPaginatingPublic = true
        guard let model = modelDataPublic.items else { return }
        let count = model.count
        print("modelData.count = \(count)")
        
        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return }
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources/public")
        components?.queryItems = [
            URLQueryItem(name: "preview_size", value: "L"),
            URLQueryItem(name: "preview_crop", value: "false"),
            URLQueryItem(name: "limit", value: "10"),
            URLQueryItem(name: "offset", value: "\(count)")
        ]
        guard let url = components?.url else {
            self.isPaginatingPublic = false
            return
        }
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data else {
                print("additionalGetting - No internet")
                errorHandler()
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let latestFiles = try? decoder.decode(LatestFiles.self, from: data) else {
                print("Error serialization")
                guard let self = self else { return }
                self.isPaginatingPublic = false
                return
            }
            guard let self = self else { return }
            guard let files = latestFiles.items else {
                isPaginatingPublic = false
                return
            }
            self.modelDataPublic.items?.append(contentsOf: files)
            completion()

            isPaginatingPublic = false
            print("isPaging = \(isPaginatingPublic)")
        }
        task.resume()
    }
    
    // Remove Published File/Folder
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
    
    //Getting data of published File
    func getDataOfPublishedFiles(
        publicUrl: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void,
        noInternet: @escaping () -> Void
    ) {
        guard let publicUrl = publicUrl else { return }
        let valueUrl = URLComponents(string: "\(publicUrl)")
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/public/resources")
        components?.queryItems = [URLQueryItem(name: "public_key", value: "\(String(describing: valueUrl))")]
        guard let url = components?.url else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data else {
                print("No internet get data: \(String(describing: error))")
                noInternet()
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let publishedFolder = try? decoder.decode(LatestFiles.self, from: data) else {
                print("Error DataFolder serialization")
                return
            }
            guard let self = self else { return }
            guard publishedFolder.items?.count != 0 else {
                errorHandler()
                return
            }
            self.modelDataPublic = publishedFolder
            completion()
        }
        task.resume()
    }

    // Getting data of published Folder
    func getDataOfPublishedFolder (
        publicUrl: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void,
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
                return
            }
            guard let self = self else { return }
            let filesInFolder = publishedFolder.embedded
            guard let items = filesInFolder.items else { return }
            guard items.count != 0 else {
                errorHandler()
                return }
            self.modelDataPublic = filesInFolder
            completion()
        }
        task.resume()
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
    
    // MARK: - All Files Open Folder
    
   
}
