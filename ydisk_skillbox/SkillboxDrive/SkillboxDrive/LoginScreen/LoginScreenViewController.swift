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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        configureViews()
        configureConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirst {
            updateData()
        }
        isFirst = false
    }
    
    private func configureViews() {
        
        logoImage.image = presenter.getImage()
        logoImage.contentMode = .center
        
        enterButton.backgroundColor = presenter.getColor()
        enterButton.setTitle(presenter.getText(), for: .normal)
        enterButton.setTitleColor(.white, for: .normal)
        enterButton.layer.cornerRadius = 7
        enterButton.addTarget(self, action: #selector(didTapOnEnterButton), for: .touchUpInside)
    }
    
    @objc private func didTapOnEnterButton() {
        
        presenter.didTapOnButton()
        self.dismiss(animated: true, completion: nil)
    }
    
    private func configureConstraints() {
        
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoImage)
        view.addSubview(enterButton)
        
        NSLayoutConstraint.activate([
            logoImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            logoImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            logoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            logoImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            enterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            enterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            enterButton.heightAnchor.constraint(equalToConstant: 50),
            enterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
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

