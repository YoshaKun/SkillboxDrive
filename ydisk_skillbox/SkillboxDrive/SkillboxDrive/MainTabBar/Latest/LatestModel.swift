//
//  LatestModel.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 16.11.2023.
//

import Foundation
import RealmSwift

final class LatestModel {
    
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
            savedArray.append(publicFilesList)
            realm.beginWrite()
            realm.add(publicFilesList)
            try! realm.commitWrite()
        }
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
    
    func getLatestFiles(completion: @escaping () -> Void, noInternet: @escaping () -> Void) {
        
        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return }
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources/last-uploaded")
        components?.queryItems = [URLQueryItem(name: "preview_size", value: "L"), URLQueryItem(name: "preview_crop", value: "false")]
        guard let url = components?.url else { return }
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data else {
                print("Error: \(String(describing: error))")
                noInternet()
                return }
            guard let latestFiles = try? JSONDecoder().decode(LatestFiles.self, from: data) else {
                print("Error serialization")
                return }
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
    
    func getFileFromPath(path: String?, completion: @escaping () -> Void, errorHandler: @escaping () -> Void) {
        
        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return }
        guard let pathUrl = path else { return }

        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources")
        components?.queryItems = [URLQueryItem(name: "path", value: "\(pathUrl)")]

        guard let url = components?.url else { return }
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data else {
                print("Error: \(String(describing: error))")
                return }
            guard let files = try? JSONDecoder().decode(LatestItems.self, from: data) else {
                print("Error serialization")
                errorHandler()
                return }
            completion()
        }
        task.resume()
    }
}
