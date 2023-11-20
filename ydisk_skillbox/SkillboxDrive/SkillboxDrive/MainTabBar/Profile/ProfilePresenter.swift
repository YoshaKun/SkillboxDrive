//
//  ProfilePresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 25.10.2023.
//

import Foundation
import UIKit

protocol ProfilePresenterProtocol {
    
    func didTapOnYesAlert()
    func updateToken(newToken: String?)
    func getConvertedBytesTotal(value: Int) -> Double
    func getConvertedBytesUsed(value: Int) -> Double
    func getConvertedBytesTotalToString(value: Int) -> String
    func getConvertedBytesUsedToString(value: Int) -> String
    func getConvertedBytesRemainsToString(total: Int, used: Int) -> String
    func updatePieData(completion: @escaping (_ totalSpace: Int?, _ usedSpace: Int?) -> Void)
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    func updatePieData(completion: @escaping (_ totalSpace: Int?, _ usedSpace: Int?) -> Void) {
        
        model.updatePieChartData(completion: completion)
    }
    
    
    private var model: ProfileModel = ProfileModel()
    private let loginModel: LoginScreenModel = LoginScreenModel()
    
    func didTapOnYesAlert() {
        
        DispatchQueue.main.async {
            let cookiesCleaner = WebCacheCleaner()
            cookiesCleaner.clean()
        }
        loginModel.token.removeAll()
        UserDefaults.standard.removeObject(forKey: Keys.apiToken)
        print("Did token deleted? = \(loginModel.token.isEmpty)")
        Core.shared.setNewUser()
        print("Did user deleted? = \(Core.shared.isNewUser())")
    }
    
    func updateToken(newToken: String?) {
        
        guard let newToken = newToken else { return }
        loginModel.token = newToken
        UserDefaults.standard.set(newToken, forKey: Keys.apiToken)
        print("token = \(loginModel.token)")
    }
    
    func getConvertedBytesTotal(value: Int) -> Double {
        
        let converter = Units(bytes: Int64(value))
        return converter.gigabytes
    }
    
    func getConvertedBytesUsed(value: Int) -> Double {
        
        let converter = Units(bytes: Int64(value))
        return converter.gigabytes
    }
    
    func getConvertedBytesTotalToString(value: Int) -> String {
        
        let converter = Units(bytes: Int64(value))
        return converter.getReadableUnit()
    }
    
    func getConvertedBytesUsedToString(value: Int) -> String {
        
        let converter = Units(bytes: Int64(value))
        return converter.getReadableUnit()
    }
    
    func getConvertedBytesRemainsToString(total: Int, used: Int) -> String {

        let remain = total - used
        let converter = Units(bytes: Int64(remain))
        return converter.getReadableUnit()
    }
}
