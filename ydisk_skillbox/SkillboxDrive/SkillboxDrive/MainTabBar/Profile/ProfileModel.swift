//
//  ProfileModel.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 25.10.2023.
//

import Foundation
import RealmSwift

final class ProfileModel {

    // MARK: - Initializing member of Realm
    let realm = try! Realm()
    
    // MARK: - Realm saving Data
    private func savePieChartDataUsingRealm(used: Int, total: Int) {
        
        let chartData = PieChartModel()
        chartData.busy = used
        chartData.free = total
        realm.beginWrite()
        realm.add(chartData)
        try! realm.commitWrite()
    }
    
    // MARK: - Realm delete Data
    private func deletePieChartDataFromRealm() {
    
        realm.beginWrite()
        realm.delete(realm.objects(PieChartModel.self))
        try! realm.commitWrite()
    }
    
    // MARK: - Realm READ data
    func readPieChartDataRealm(completion: @escaping (_ totalSpace: Int?, _ usedSpace: Int?) -> Void) {
        
        let someDate = self.realm.objects(PieChartModel.self)
        let usedData = someDate[0].busy
        let totalData = someDate[0].free
        completion(totalData, usedData)
    }
    
    // MARK: - Update PieChart data
    
    func updatePieChartData(completion: @escaping (_ totalSpace: Int?, _ usedSpace: Int?) -> Void, errorHandler: @escaping () -> Void) {
        
        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return }
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk")
        
        guard let url = components?.url else { return }
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Error: \(String(describing: error))")
                errorHandler()
                return }
            guard let newFiles = try? JSONDecoder().decode(DiskSpaceResponse.self, from: data) else { return }
            guard let total = newFiles.total_space, let used = newFiles.used_space else { return }
            DispatchQueue.main.async {
                self.deletePieChartDataFromRealm()
                self.savePieChartDataUsingRealm(used: used, total: total)
            }
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
