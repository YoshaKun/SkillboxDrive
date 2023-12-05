//
//  LatestModel.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 16.11.2023.
//

import Foundation
import RealmSwift

final class LatestModel {
    
    // MARK: - Pagination FLAG
    var isPaginating = false
    
    // MARK: - Initializing member of Realm
    let realm = try! Realm()
    
    // MARK: - Base Model data
    var modelData = LatestFiles(items: [])
    
    // MARK: - Realm saving Data
    private func savePublicFilesUsingRealm(filesList: LatestFiles) {
        
        guard let array = filesList.items else { return }
        var savedArray: [LatestRealmModel] = []
        for items in array {
            let publicFilesList = LatestRealmModel()
            publicFilesList.name = items.name
            publicFilesList.created = items.created
            publicFilesList.path = items.path
            publicFilesList.type = items.type
            publicFilesList.size = items.size ?? 0
            publicFilesList.preview = items.preview
            publicFilesList.file = items.file
            savedArray.append(publicFilesList)
        }
        realm.beginWrite()
        realm.add(savedArray)
        try! realm.commitWrite()
    }
    
    // MARK: - Realm delete Data
    private func deletePublicFilesRealm() {
    
        realm.beginWrite()
        realm.delete(realm.objects(LatestRealmModel.self))
        try! realm.commitWrite()
    }
    
    // MARK: - Realm READ data
    func readPublicFilesRealm() -> LatestFiles {
        
        let savedDataInRealm = realm.objects(LatestRealmModel.self)
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

        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data else {
                print("Error: \(String(describing: error))")
                noInternet()
                return
            }
            guard let latestFiles = try? JSONDecoder().decode(LatestFiles.self, from: data) else {
                print("Error serialization")
                return
            }
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.deletePublicFilesRealm()
                self.savePublicFilesUsingRealm(filesList: latestFiles)
            }
            self.modelData = latestFiles
            completion()
        }
        task.resume()
    }
    
    // MARK: - Get data for open files
    func getFileFromPath(
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

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("Error: \(String(describing: error))")
                return }
            guard (try? JSONDecoder().decode(LatestItems.self, from: data)) != nil else {
                print("Error serialization")
                errorHandler()
                return }
            completion()
        }
        task.resume()
    }
    
    // MARK: - Additional getting latest files (Пагинация)
    func additionalGetingLatestFiles (
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    ) {
        
        isPaginating = true
        guard let model = modelData.items else { return }
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
            self.isPaginating = false
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
            guard let latestFiles = try? JSONDecoder().decode(LatestFiles.self, from: data) else {
                print("Error serialization")
                guard let self = self else { return }
                self.isPaginating = false
                return
            }
            guard let self = self else { return }
            guard latestFiles.items != nil else {
                isPaginating = false
                return
            }
            self.modelData = latestFiles
            completion()
            DispatchQueue.main.async {
                self.savePublicFilesUsingRealm(filesList: latestFiles)
            }
            isPaginating = false
            print("isPaging = \(isPaginating)")
        }
        task.resume()
    }
}
