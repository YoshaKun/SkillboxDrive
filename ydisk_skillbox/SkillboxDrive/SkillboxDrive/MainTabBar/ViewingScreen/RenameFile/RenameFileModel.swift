//
//  RenameFileModel.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 25.11.2023.
//

import Foundation

final class RenameFileModel {
    
    func renameFile(from: String?, path: String?, completion: @escaping () -> Void) {
        
        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return }
        guard let from = from, let path = path else { return }
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources/move")
        components?.queryItems = [URLQueryItem(name: "from", value: "\(from)"),
                                  URLQueryItem(name: "path", value: "\(path)")
                                 ]
        
        guard let url = components?.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("Error: \(String(describing: error))")
                return }
            guard let response = response else {
                print("Error: \(String(describing: error))")
                return }
            print("Rename respone: \(response)")
            completion()
        }
        task.resume()
    }
}
