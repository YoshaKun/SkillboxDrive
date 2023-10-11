//
//  ViewController.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 05.10.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Показываем Онборд новому пользователю 1 раз
        if Core.shared.isNewUser() {
            let vc = OnboardingViewController()
            // Модальное представление на полный экран, чтобы нельзя было смахнуть онбординг
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        }
        
    }
}

class Core {
    
    static let shared = Core()
    
    func isNewUser() -> Bool {
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
}


