//
//  ProfilePresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 25.10.2023.
//

import Foundation
import UIKit

protocol ProfilePresenterProtocol {
    
    func setView(_ view: ProfileViewControllerProtocol)
    func didTapOnYesAlert()
    func didTapOnPublicButton()
}

final class ProfilePresenter: ProfilePresenterProtocol {

    private var view: ProfileViewControllerProtocol?
    private var model: ProfileModel = ProfileModel()

    private let loginModel: LoginScreenModel = LoginScreenModel()
    
    func setView(_ view: ProfileViewControllerProtocol) {
        
        self.view = view
    }
    
    func didTapOnYesAlert() {
        
        DispatchQueue.main.async {
            let cookiesCleaner = WebCacheCleaner()
            cookiesCleaner.clean()
        }
        loginModel.token.removeAll()
        print("Did token deleted? = \(loginModel.token.isEmpty)")
        Core.shared.setNewUser()
        print("Did user deleted? = \(Core.shared.isNewUser())")
    }
    
    func didTapOnPublicButton() {
        print("Called method didTapOnPublicButton")
    }
}
