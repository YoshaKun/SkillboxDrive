//
//  PublicFilesModel.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 13.11.2023.
//

import Foundation
import RealmSwift

final class PublicFilesModel {
    
    // MARK: - Pagination FLAG
    var isPaginating = false
    
    // MARK: - Initializing member of Realm
    let realm = try! Realm()
    
    // MARK: - Base Model data
    var modelData = LatestFiles(items: [])
    
    // MARK: - Realm saving Data
    private func savePublicFilesUsingRealm(filesList: LatestFiles) {
        
        guard let array = filesList.items else { return }
        var savedArray: [PublicRealmModel] = []
        for items in array {
            let publicFilesList = PublicRealmModel()
            publicFilesList.name = items.name
            publicFilesList.created = items.created
            publicFilesList.path = items.path
            publicFilesList.type = items.type
            publicFilesList.size = items.size ?? 0
            publicFilesList.preview = items.preview
            publicFilesList.file = items.file
            publicFilesList.public_url = items.public_url
            savedArray.append(publicFilesList)
            realm.beginWrite()
            realm.add(publicFilesList)
            try! realm.commitWrite()
        }
    }
    
    // MARK: - Realm delete Data
    private func deletePublicFilesRealm() {
    
        realm.beginWrite()
        realm.delete(realm.objects(PublicRealmModel.self))
        try! realm.commitWrite()
    }
    
    // MARK: - Realm READ data
    func readPublicFilesRealm() -> LatestFiles {
        
        let savedDataInRealm = realm.objects(PublicRealmModel.self)
        var publicFiles = LatestFiles(items: [])
        
        for data in savedDataInRealm {
            let latestItem = LatestItems(
                name: data.name!,
                created: data.created!,
                sizes: [],
                file: data.file,
                path: data.path!,
                type: data.type!,
                size: data.size,
                preview: data.preview,
                public_url: data.public_url
            )
            publicFiles.items?.append(latestItem)
        }
        return publicFiles
    }
    
    // MARK: - Get published files
    func getPublishedFiles (completion: @escaping () -> Void, errorHandler: @escaping () -> Void, noInternet: @escaping () -> Void) {
        
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
            guard let latestFiles = try? JSONDecoder().decode(LatestFiles.self, from: data) else {
                print("Error serialization")
                return }
            guard let self = self else { return }
            guard latestFiles.items?.count != 0 else { 
                errorHandler()
                return }
            DispatchQueue.main.async {
                self.deletePublicFilesRealm()
                self.savePublicFilesUsingRealm(filesList: latestFiles)
            }
            self.modelData = latestFiles
            completion()
            print("Количество ячеек = \(self.modelData.items?.count ?? 000)")
        }
        task.resume()
    }
    
//    // MARK: - Additional getting published files (Пагинация)
//    
//    func additionalGetingPublishedFiles (pagination: Bool = false, completion: @escaping () -> Void, errorHandler: @escaping () -> Void) {
//        
//        if pagination {
//            isPaginating = true
//        }
//        guard let model = modelData.items else { return }
//        let count = model.count
//        print("modelData.count = \(count)")
//        
//        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return }
//        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources/public")
//        components?.queryItems = [URLQueryItem(name: "preview_size", value: "L"),
//                                  URLQueryItem(name: "preview_crop", value: "false"),
//                                  URLQueryItem(name: "limit", value: "5"),
//                                  URLQueryItem(name: "offset", value: "\(count)"),]
//        guard let url = components?.url else { return }
//        var request = URLRequest(url: url)
//        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
//
//        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
//            guard let data = data else {
//                print("additionalGetting - No internet: \(String(describing: error))")
//                if pagination {
//                    guard let self = self else { return }
//                    self.isPaginating = false
//                }
//                return }
//            guard let latestFiles = try? JSONDecoder().decode(LatestFiles.self, from: data) else {
//                print("Error serialization")
//                if pagination {
//                    guard let self = self else { return }
//                    self.isPaginating = false
//                }
//                return }
//            guard let self = self else { return }
//            guard latestFiles.items?.count != 0 else {
//                errorHandler()
//                if pagination {
//                    isPaginating = false
//                }
//                return }
//            guard let files = latestFiles.items else { return }
//            DispatchQueue.main.async {
//                self.savePublicFilesUsingRealm(filesList: latestFiles)
//            }
//            self.modelData.items?.append(contentsOf: files)
//            if pagination {
//                isPaginating = false
//            }
//            completion()
//        }
//        task.resume()
//    }
    
    func removePublishedFile (path: String?, completion: @escaping () -> Void, errorHendler: @escaping () -> Void) {
        
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
    
    func getDataOfPublishedFiles(publicUrl: String?, completion: @escaping () -> Void, errorHandler: @escaping () -> Void, noInternet: @escaping () -> Void) {
        
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
            guard let publishedFolder = try? JSONDecoder().decode(LatestFiles.self, from: data) else {
                print("Error DataFolder serialization")
                return
            }
            guard let self = self else { return }
            guard publishedFolder.items?.count != 0 else {
                errorHandler()
                return
            }
            self.modelData = publishedFolder
            completion()
        }
        task.resume()
    }

    func getDataOfPublishedFolder (publicUrl: String?, completion: @escaping () -> Void, errorHandler: @escaping () -> Void, noInternet: @escaping () -> Void) {
        
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
            guard let publishedFolder = try? JSONDecoder().decode(PublishedFolder.self, from: data) else {
                print("Error published folder decode: \(String(describing: response))")
                return
            }
            guard let self = self else { return }
            let filesInFolder = publishedFolder._embedded
            guard let items = filesInFolder.items else { return }
            guard items.count != 0 else {
                errorHandler()
                return }
            self.modelData = filesInFolder
            completion()
        }
        task.resume()
    }
    
//    // MARK: - Additional getting published folder (Пагинация)
//    
//    func additionalGetingPublishedFolder (pagination: Bool = false, publicUrl: String?, completion: @escaping () -> Void, errorHandler: @escaping () -> Void) {
//        
//        if pagination {
//            isPaginating = true
//        }
//        guard let model = modelData.items else { return }
//        let count = model.count
//        print("modelData.count = \(count)")
//        
//        guard let publicUrl = publicUrl else { return }
//        print(publicUrl)
//
//        guard let valueUrl = URLComponents(string: "\(publicUrl)") else { return }
//        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/public/resources")
//        components?.queryItems = [URLQueryItem(name: "public_key", value: "\(String(describing: valueUrl))"),
//                                  URLQueryItem(name: "limit", value: "5"),
//                                  URLQueryItem(name: "offset", value: "\(count)"),]
//        
//        guard let url = components?.url else { return }
//        var request = URLRequest(url: url)
//
//        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
//            guard let data = data else {
//                print("additionalGetting folder- No internet: \(String(describing: error))")
//                if pagination {
//                    guard let self = self else { return }
//                    self.isPaginating = false
//                }
//                return }
//            guard let publishedFolder = try? JSONDecoder().decode(PublishedFolder.self, from: data) else {
//                print("Error serialization")
//                if pagination {
//                    guard let self = self else { return }
//                    self.isPaginating = false
//                }
//                return }
//            guard let self = self else { return }
//            let filesInFolder = publishedFolder._embedded
//            guard let items = filesInFolder.items else { return }
//            guard items.count != 0 else {
//                errorHandler()
//                if pagination {
//                    isPaginating = false
//                }
//                return }
//            DispatchQueue.main.async {
//                self.savePublicFilesUsingRealm(filesList: filesInFolder)
//            }
//            self.modelData.items?.append(contentsOf: items)
//            if pagination {
//                isPaginating = false
//            }
//            completion()
//        }
//        task.resume()
//    }
}
