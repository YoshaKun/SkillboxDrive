//
//  SplashScreenViewController.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 11.10.2023.
//

import UIKit

final class LoginScreenViewController: UIViewController {
    
    private let presenter: LoginScreenPresenterProtocol = LoginScreenPresenter()
    private let logoImage = UIImageView()
    private let enterButton = UIButton()
    private let showOnbordButton = UIButton()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureViews()
        configureConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // MARK: - Showing the Onboarding
        // Если надо устанавливаем заново Нового пользователя в Юзер дефолтс
//        Core.shared.setNewUser()
        
        // Показываем Онборд новому пользователю 1 раз
        if Core.shared.isNewUser() {
            guard let vc = presenter.didTapOnOnboardButton() else { return }
            present(vc, animated: false)
        }
    }

    private func configureViews() {
        
        view.backgroundColor = .white
        logoImage.image = presenter.getImage()
        logoImage.contentMode = .center
        
        enterButton.backgroundColor = presenter.getColor()
        enterButton.setTitle(presenter.getTextEnterBtn(), for: .normal)
        enterButton.setTitleColor(.white, for: .normal)
        enterButton.layer.cornerRadius = 7
        enterButton.addTarget(self, action: #selector(didTapOnEnterButton), for: .touchUpInside)
        
        showOnbordButton.backgroundColor = presenter.getColor()
        showOnbordButton.setTitle(presenter.getTextOnbordBtn(), for: .normal)
        showOnbordButton.setTitleColor(.white, for: .normal)
        showOnbordButton.layer.cornerRadius = 7
        showOnbordButton.addTarget(self, action: #selector(didTappedOnOnboardButton), for: .touchUpInside)
    }
    
    @objc private func didTapOnEnterButton() {
        
        updateData()
        guard let tabBarController = presenter.didTapOnButton() else { return }
        present(tabBarController, animated: true, completion: nil)
    }

    @objc private func didTappedOnOnboardButton() {
        
        guard let vc = presenter.didTapOnOnboardButton() else { return }
        present(vc, animated: true, completion: nil)
    }
    
    private func configureConstraints() {
        
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        showOnbordButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoImage)
        view.addSubview(enterButton)
        view.addSubview(showOnbordButton)
        
        NSLayoutConstraint.activate([
            logoImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            logoImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            logoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            logoImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            enterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            enterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            enterButton.heightAnchor.constraint(equalToConstant: 50),
            enterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            
            showOnbordButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            showOnbordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            showOnbordButton.heightAnchor.constraint(equalToConstant: 30),
            showOnbordButton.widthAnchor.constraint(equalToConstant: 80),
        ])
    }
    
    private func updateData() {
        
        if Core.shared.isNewUser() {
            let requestTokenViewController = AuthViewController()
            requestTokenViewController.delegate = self
            present(requestTokenViewController, animated: false, completion: nil)
            return
        }
        print("UpdateData. Token is Empty? - \(String(describing: presenter.getToken()?.isEmpty))")
        guard !(presenter.getToken()?.isEmpty ?? true) else {
            let requestTokenViewController = AuthViewController()
            requestTokenViewController.delegate = self
            present(requestTokenViewController, animated: false, completion: nil)
            return
        }
    }
}

extension LoginScreenViewController: AuthViewControllerDelegate {
    
    func handleTokenChanged(token: String) {
        presenter.updateToken(newToken: token)
        updateData()
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

