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

    // MARK: - Profile Screen 2 - Main List of Published Files
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
}
