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
    func didTapOnButton() -> UIViewController?
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    private var view: ProfileViewControllerProtocol?
    private var model: ProfileModel = ProfileModel()
    
    func setView(_ view: ProfileViewControllerProtocol) {
        
        self.view = view
    }
    
    func didTapOnButton() -> UIViewController? {
        
        return UIViewController()
    }
    
}
