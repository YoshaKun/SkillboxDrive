//
//  LoginScreenPresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 12.10.2023.
//

import UIKit

protocol LoginScreenPresenterProtocol {
    
    func getColor() -> UIColor
    func getText() -> String
    func getImage() -> UIImage?
    func didTapOnButton()
}

final class LoginScreenPresenter: LoginScreenPresenterProtocol {
    
    private let model: LoginScreenModel = LoginScreenModel()
    
    func getColor() -> UIColor {
        
        guard let color = model.constant.Colors.blueSpecial else { return .blue }
        return color
    }
    
    func getText() -> String {
        
        let string = model.constant.Text.loginButton
        return string
    }
    
    func getImage() -> UIImage? {
        
        model.constant.Image.logo1
    }
    
    func didTapOnButton() {
        
        print("Сработал метод didTapOnButton")
    }
    
}
