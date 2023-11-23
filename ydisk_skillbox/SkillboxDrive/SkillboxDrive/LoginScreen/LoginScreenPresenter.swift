//
//  LoginScreenPresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 12.10.2023.
//

import UIKit

protocol LoginScreenPresenterProtocol {
    
    func getColor() -> UIColor
    func getTextEnterBtn() -> String
    func getTextOnbordBtn() -> String
    func getImage() -> UIImage?
    func didTapOnButton() -> UITabBarController?
    func didTapOnOnboardButton() -> UIViewController?
    func getToken() -> String
    func updateToken(newToken: String?)
}

final class LoginScreenPresenter: LoginScreenPresenterProtocol {
    
    private let model: LoginScreenModel = LoginScreenModel()
    
    func getColor() -> UIColor {
        
        guard let color = model.constant.Colors.blueSpecial else { return .blue }
        return color
    }
    
    func getTextEnterBtn() -> String {
        
        let string = model.constant.Text.loginButton
        return string
    }
    
    func getTextOnbordBtn() -> String {
        
        let string = model.constant.Text.OnboardButton
        return string
    }
    
    func getImage() -> UIImage? {
        
        model.constant.Image.logo1
    }
    
    func didTapOnButton() -> UITabBarController? {
        
        let tabBarVC = UITabBarController()
        let firstVC = UINavigationController(rootViewController: ProfileViewController())
        let secondVC = UINavigationController(rootViewController: LatestViewController())
        let thirdVC = UINavigationController(rootViewController: AllFilesViewController())
        tabBarVC.setViewControllers([firstVC, secondVC, thirdVC], animated: false)
        tabBarVC.modalPresentationStyle = .fullScreen
        return tabBarVC
    }
    
    func didTapOnOnboardButton() -> UIViewController? {
        
        let onboardVC = OnboardingViewController()
        onboardVC.modalPresentationStyle = .fullScreen
        
        return onboardVC
    }
    
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
