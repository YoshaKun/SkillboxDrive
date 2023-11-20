//
//  ProfileModel.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 25.10.2023.
//

import Foundation

final class ProfileModel {

    func updatePieChartData(completion: @escaping (_ totalSpace: Int?, _ usedSpace: Int?) -> Void) {
        
        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return }
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk")
        
        guard let url = components?.url else { return }
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self, let data = data else {
                print("Error: \(String(describing: error))")
                return }
            guard let newFiles = try? JSONDecoder().decode(DiskSpaceResponse.self, from: data) else { return }
            guard let total = newFiles.total_space, let used = newFiles.used_space else { return }
            
            completion(total, used)
        }
        task.resume()
    }
}

public struct Units {
  
  public let bytes: Int64
  
  public var kilobytes: Double {
    return Double(bytes) / 1_024
  }
  
  public var megabytes: Double {
    return kilobytes / 1_024
  }
  
  public var gigabytes: Double {
    return megabytes / 1_024
  }
  
  public init(bytes: Int64) {
    self.bytes = bytes
  }
  
  public func getReadableUnit() -> String {
    
    switch bytes {
    case 0..<1_024:
      return "\(bytes) bytes"
    case 1_024..<(1_024 * 1_024):
      return "\(String(format: "%.2f", kilobytes)) " + Constants.Text.kb
    case 1_024..<(1_024 * 1_024 * 1_024):
        return "\(String(format: "%.2f", megabytes)) " + Constants.Text.mb
    case (1_024 * 1_024 * 1_024)...Int64.max:
        return "\(String(format: "%.2f", gigabytes)) " + Constants.Text.gb
    default:
      return "\(bytes) bytes"
    }
  }
}
