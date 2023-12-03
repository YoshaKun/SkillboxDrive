//
//  OpenFolderModel.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 02.12.2023.
//

import Foundation
import RealmSwift

final class OpenFolderModel {
    
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
    
    
    func getAllFiles(path: String?, completion: @escaping () -> Void, errorHandler: @escaping () -> Void, noInternet: @escaping () -> Void) {
        
        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return }
        guard let pathUrl = path else { return }

        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources")
        components?.queryItems = [
            URLQueryItem(name: "path", value: "\(pathUrl)"),
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
}
