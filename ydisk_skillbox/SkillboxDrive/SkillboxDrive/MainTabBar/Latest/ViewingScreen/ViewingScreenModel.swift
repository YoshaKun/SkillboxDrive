//
//  ViewingScreenModel.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 20.11.2023.
//

import Foundation

final class ViewingScreenModel {
    
    func getImageForView(urlStr: String, completion: @escaping (Data) -> Void) {
        
        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return }
        var components = URLComponents(string: "\(urlStr)")

        guard let url = components?.url else { return }
        var request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data else {
                print("Error: \(String(describing: error))")
                return }
            completion(data)
        }
        task.resume()
    }
}
