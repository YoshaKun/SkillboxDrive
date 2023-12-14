//
//  ProfileModel.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 25.10.2023.
//

import Foundation

final class ProfileModel {

    // MARK: - Update token
    func updateToken(newToken: String?) {
        guard let newToken = newToken else { return }
        UserDefaults.standard.set(newToken, forKey: Keys.apiToken)
    }
    
    // MARK: - Did tap on YES Alert button
    func didTapOnYesAlert() {
        UserDefaults.standard.removeObject(forKey: Keys.apiToken)
        print("Did token deleted? = \(Keys.apiToken.isEmpty)")
        Core.shared.setNewUser()
        print("Did user deleted? = \(Core.shared.isNewUser())")
        DispatchQueue.main.async {
            let cookiesCleaner = WebCacheCleaner()
            cookiesCleaner.clean()
        }
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
