//
//  jkgsdjkhf.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 02.12.2023.
//

import Foundation
import RealmSwift

final class AllFilesModel {
    
    // MARK: - Pagination FLAG
    var isPaginating = false
    
    // MARK: - Initializing member of Realm
    let realm = try! Realm()
    
    // MARK: - Base Model data
    var modelData = LatestFiles(items: [])
    
    // MARK: - Realm saving Data
    private func savePublicFilesUsingRealm(filesList: LatestFiles) {
        
        guard let array = filesList.items else { return }
        var savedArray: [AllFilesRealmModel] = []
        for items in array {
            let publicFilesList = AllFilesRealmModel()
            publicFilesList.name = items.name
            publicFilesList.created = items.created
            publicFilesList.path = items.path
            publicFilesList.type = items.type
            publicFilesList.size = items.size ?? 0
            publicFilesList.preview = items.preview
            publicFilesList.file = items.file
            savedArray.append(publicFilesList)
            realm.beginWrite()
            realm.add(publicFilesList)
            try! realm.commitWrite()
        }
    }
    
    // MARK: - Realm delete Data
    private func deletePublicFilesRealm() {
    
        realm.beginWrite()
        realm.delete(realm.objects(AllFilesRealmModel.self))
        try! realm.commitWrite()
    }
    
    // MARK: - Realm READ data
    func readPublicFilesRealm() -> LatestFiles {
        
        let savedDataInRealm = realm.objects(AllFilesRealmModel.self)
        var latestFiles = LatestFiles(items: [])
        
        for data in savedDataInRealm {
            let latestItem = LatestItems(
                name: data.name!,
                created: data.created!,
                sizes: [],
                file: nil,
                path: data.path!,
                type: data.type!,
                size: data.size,
                preview: data.preview,
                public_url: nil
            )
            latestFiles.items?.append(latestItem)
        }
        return latestFiles
    }
    
    // MARK: - Update tableView method
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

        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data else {
                print("No internet get data: \(String(describing: error))")
                noInternet()
                return
            }
            guard let allFilesFolder = try? JSONDecoder().decode(PublishedFolder.self, from: data) else {
                print("Error serialization")
                errorHandler()
                return
            }
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.deletePublicFilesRealm()
                self.savePublicFilesUsingRealm(filesList: allFilesFolder._embedded)
            }
            let items = allFilesFolder._embedded.items
            self.modelData.items = items
            completion()
        }
        task.resume()
    }
    
    // MARK: - Additional getting all files (Пагинация)
    func additionalGetingAllFiles (
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    ) {

        isPaginating = true
        
        guard let model = modelData.items else { return }
        let count = model.count
        print("modelData.count = \(count)")

        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return }
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources")
        components?.queryItems = [
            URLQueryItem(name: "path", value: "disk:/"),
            URLQueryItem(name: "preview_size", value: "L"),
            URLQueryItem(name: "preview_crop", value: "false"),
            URLQueryItem(name: "limit", value: "5"),
            URLQueryItem(name: "offset", value: "\(count)"),
        ]
        guard let url = components?.url else {
            self.isPaginating = false
            return
        }
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data else {
                print("additionalGetting - No internet: \(String(describing: error))")
                errorHandler()
                return
            }
            guard let allFilesFolder = try? JSONDecoder().decode(PublishedFolder.self, from: data) else {
                print("Error serialization")
                guard let self = self else { return }
                self.isPaginating = false
                return
            }
            guard let self = self else { return }
            guard let items = allFilesFolder._embedded.items else {
                isPaginating = false
                return
            }
            self.modelData.items?.append(contentsOf: items)
            completion()
            DispatchQueue.main.async {
                self.savePublicFilesUsingRealm(filesList: allFilesFolder._embedded)
            }
            isPaginating = false
            print("isPaging = \(isPaginating)")
        }
        task.resume()
    }
    
    // MARK: - Get data of Folder, after tap on cell
    func getDataFolder(
        path: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void,
        noInternet: @escaping () -> Void
    ) {
        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return }
        guard let path = path else {
            print("path error")
            return
        }
        print("\(path)")
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources")
        components?.queryItems = [
            URLQueryItem(name: "path", value: "\(path)"),
            URLQueryItem(name: "preview_size", value: "L"),
            URLQueryItem(name: "preview_crop", value: "false")
        ]

        guard let url = components?.url else { return }
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data else {
                print("No internet get data: \(String(describing: error))")
                noInternet()
                return
            }
            guard let allFilesFolder = try? JSONDecoder().decode(PublishedFolder.self, from: data) else {
                print("Error serialization")
                errorHandler()
                return
            }
            guard let self = self else { return }
            completion()
        }
        task.resume()
    }
    
    // MARK: - Get data of File, after tap on cell
    func getDataOfOpenFile(
        path: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void,
        noInternet: @escaping () -> Void
    ) {
        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return }
        guard let path = path else {
            print("path error")
            return
        }
        print("\(path)")
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources")
        components?.queryItems = [
            URLQueryItem(name: "path", value: "\(path)"),
            URLQueryItem(name: "preview_size", value: "L"),
            URLQueryItem(name: "preview_crop", value: "false")
        ]

        guard let url = components?.url else { return }
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data else {
                print("No internet get data: \(String(describing: error))")
                noInternet()
                return
            }
            guard let allFilesFolder = try? JSONDecoder().decode(LatestItems.self, from: data) else {
                print("Error serialization")
                errorHandler()
                return
            }
            guard let self = self else { return }
            completion()
        }
        task.resume()
    }
}

    
