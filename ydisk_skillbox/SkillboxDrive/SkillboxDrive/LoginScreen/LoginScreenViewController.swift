//
//  SplashScreenViewController.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 11.10.2023.
//

import UIKit

final class LoginScreenViewController: UIViewController {
    
    // TOKEN - потом перенести его в модель LoginScreenModel
    private var token: String = ""
    private var isFirst = true
    
    private let presenter: LoginScreenPresenterProtocol = LoginScreenPresenter()
    private let logoImage = UIImageView()
    private let enterButton = UIButton()
    private let showOnbordButton = UIButton()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        configureViews()
        configureConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // MARK: - Showing the Onboarding
        // Если надо устанавливаем заново Нового пользователя в Юзер дефолтс
        Core.shared.setNewUser()
        
        // Показываем Онборд новому пользователю 1 раз
        if Core.shared.isNewUser() {
            guard let vc = presenter.didTapOnOnboardButton() else { return }
            present(vc, animated: false)
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        if isFirst {
//            updateData()
//        }
//        isFirst = false
//    }
    
    private func configureViews() {
        
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
        
        guard !token.isEmpty else {
            let requestTokenViewController = AuthViewController()
            requestTokenViewController.delegate = self
            present(requestTokenViewController, animated: false, completion: nil)
            return
        }
        
//        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources/files")
//        components?.queryItems = [URLQueryItem(name: "media_type", value: "image")]
//        
//        guard let url = components?.url else { return }
//        var request = URLRequest(url: url)
//        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
//        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
//            guard let self = self, let data = data else { return }
//            guard let newFiles = try?
//                    JSONDecoder().decode(DiskResponse.self, from: data) else { return }
//            print("Received: \(newFiles.items?.count ?? 0) files")
//        }
//        task.resume()
    }
}

extension LoginScreenViewController: AuthViewControllerDelegate {
    
    func handleTokenChanged(token: String) {
        self.token = token
        print("New token: \(token)")
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

