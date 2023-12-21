//
//  LoginScreenPresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 12.10.2023.
//

import Foundation

final class LoginScreenPresenter: LoginScreenPresenterInput {
    
    func getToken() -> String {
        
        guard let token = UserDefaults.standard.string(forKey: Keys.apiToken) else { return ""}
        return token
    }
    
    func updateToken(newToken: String?) {
        
        guard let newToken = newToken else { return }
        UserDefaults.standard.set(newToken, forKey: Keys.apiToken)
        print("token = \(newToken)")
    }
}
