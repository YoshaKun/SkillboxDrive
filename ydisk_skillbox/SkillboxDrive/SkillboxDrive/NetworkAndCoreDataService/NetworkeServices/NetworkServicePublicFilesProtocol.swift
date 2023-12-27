//
//  NetworkServicePublicFilesProtocol.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 20.12.2023.
//

import Foundation

protocol NetworkServicePublicFilesProtocol: AnyObject {
    func getPublishedFiles (
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void,
        noInternet: @escaping () -> Void
    )
    func getModalDataPublic() -> LatestFilesModel
    func removePublishedFile (
        path: String?,
        completion: @escaping () -> Void,
        errorHendler: @escaping () -> Void
    )
    func getStateOfPaginatingPublic() -> Bool
    func additionalGetingPublishedFiles (
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    )
    func changePaginatingPublicStateToFalse()
}

extension NetworkService: NetworkServicePublicFilesProtocol {

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
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, _, error) in
            guard let data = data else {
                noInternet()
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let latestFiles = try? decoder.decode(LatestFilesModel.self, from: data) else {
                AlertHelper.showAlert(withMessage: "Error: \(String(describing: error?.localizedDescription))")
                return
            }
            guard let self = self else { return }
            guard latestFiles.items?.count != 0 else {
                errorHandler()
                return
            }
            self.modelDataPublic = latestFiles
            completion()
        }
        task.resume()
    }

    func getModalDataPublic() -> LatestFilesModel {
        return modelDataPublic
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
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            if let response = response  as? HTTPURLResponse {
                switch response.statusCode {
                case 200..<300:
                    completion()
                default:
                    AlertHelper.showAlert(withMessage: "Error: \(String(describing: error?.localizedDescription))")
                    errorHendler()
                }
            }
        }
        task.resume()
    }

    func getStateOfPaginatingPublic() -> Bool {
        return isPaginatingPublic
    }

    // Additional getting published files (Пагинация)
    func additionalGetingPublishedFiles (
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    ) {
        isPaginatingPublic = true
        guard let model = modelDataPublic.items else { return }
        let count = model.count
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

        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, _, error) in
            guard let data = data else {
                errorHandler()
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let latestFiles = try? decoder.decode(LatestFilesModel.self, from: data) else {
                AlertHelper.showAlert(withMessage: "Error: \(String(describing: error?.localizedDescription))")
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
        }
        task.resume()
    }
    func changePaginatingPublicStateToFalse() {
        isPaginatingPublic = false
    }
}
