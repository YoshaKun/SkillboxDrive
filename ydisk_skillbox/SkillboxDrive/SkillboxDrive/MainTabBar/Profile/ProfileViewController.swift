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
        
        view.backgroundColor = .white
        configureTabBar()
    }
    
    private func configureTabBar() {
        
        self.navigationItem.title = Constants.Text.FirstVC.title
        self.tabBarController?.tabBar.tintColor = Constants.Colors.blueSpecial
        
        guard let items = tabBarController?.tabBar.items else {
            return
        }
        
        let images = [Constants.Image.tabBar1, Constants.Image.tabBar2, Constants.Image.tabBar3]
        
        for x in 0..<items.count {
            items[x].image = images[x]
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Если надо устанавливаем заново Нового пользователя в Юзер дефолтс
//        Core.shared.setNewUser()
        
        // Показываем Онборд новому пользователю 1 раз
        if Core.shared.isNewUser() {
            let vc = OnboardingViewController()
//            let vc = LoginScreenViewController()
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
    //устанавливаем в Юзер дефолтс что у нас уже Не новый пользователь
    func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
    //устанавливаем в Юзер дефолтс что у нас Новый пользователь
    func setNewUser() {
        UserDefaults.standard.set(false, forKey: "isNewUser")
    }
}


