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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        configureViews()
        configureConstraints()
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
        
        self.dismiss(animated: true, completion: nil)
        presenter.didTapOnButton()
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
}

