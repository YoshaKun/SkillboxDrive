//
//  ViewingScreenModel.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 20.11.2023.
//

import Foundation

final class ViewingScreenModel {
    
    func getImageForView(
        urlStr: String,
        completion: @escaping (Data) -> Void
    ) {
        
        let components = URLComponents(string: "\(urlStr)")

        guard let url = components?.url else { return }
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("Error: \(String(describing: error))")
                return }
            completion(data)
        }
        task.resume()
    }
    
    func deleteFile(
        path: String?,
        completion: @escaping () -> Void
    ) {
        
        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return }
        guard let path = path else { return }
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources")
        components?.queryItems = [URLQueryItem(name: "path", value: "\(path)"),
                                  URLQueryItem(name: "force_async", value: "true"),
                                  URLQueryItem(name: "path", value: "permanently"),]
        
        guard let url = components?.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard data != nil else {
                print("Error: \(String(describing: error))")
                return }
            guard let response = response else {
                print("Error: \(String(describing: error))")
                return }
            print("DELETE Respone: \(response)")
            
            completion()
        }
        task.resume()
    }
    
    func getLinkFile(
        path: String?,
        completion: @escaping () -> Void
    ) {
        
        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return }
        guard let path = path else { return }
        print("path = \(path)")
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources/publish")
        components?.queryItems = [URLQueryItem(name: "path", value: path)]
        guard let url = components?.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            guard let files = try? JSONDecoder().decode(ShareLink.self, from: data) else {
                print("Error serialization")
                return }
            guard let link = files.href else { return }
            print("link: \(link)")
            if let response = response  as? HTTPURLResponse {
                switch response.statusCode {
                case 200..<300:
                    print("Success")
                    completion()
                default:
                    print("Status: \(response.statusCode)")
                }
            }
        }
        task.resume()
    }
}
