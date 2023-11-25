//
//  RenameFileVC.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 25.11.2023.
//

import UIKit

final class RenameFileVC: UIViewController {
    
    private let backButton = UIButton()
    private let nameFile = UILabel()
    private let readyButton = UIButton()
    private var searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureConstraints()
    }
    
    private func configureViews() {
        
        view.backgroundColor = .white
        
        backButton.setImage(Constants.Image.backArrow, for: .normal)
        backButton.addTarget(self, action: #selector(didTapOnBackButton), for: .touchUpInside)
        
        nameFile.font = .systemFont(ofSize: 17, weight: .semibold)
        nameFile.textColor = .black
        nameFile.textAlignment = .center
        nameFile.text = Constants.Text.SecondVC.rename
        
        readyButton.setTitle(Constants.Text.SecondVC.ready, for: .normal)
        readyButton.setTitleColor(Constants.Colors.blueSpecial, for: .normal)
        readyButton.addTarget(self, action: #selector(didTapOnReadyButton), for: .touchUpInside)
        
        searchBar.placeholder = "Enter some letters"
        searchBar.layer.cornerRadius = 10
        searchBar.searchTextField.borderStyle = .none
        searchBar.text = "NAME OF file"
    }
    
    @objc private func didTapOnReadyButton() {
        
        print("There was tap Ready button")
    }
    @objc private func didTapOnBackButton() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    private func configureConstraints() {
        
        let offsetWidth = view.frame.size.width / 2
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        nameFile.translatesAutoresizingMaskIntoConstraints = false
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backButton)
        view.addSubview(nameFile)
        view.addSubview(readyButton)
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            
            nameFile.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameFile.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            nameFile.widthAnchor.constraint(equalToConstant: offsetWidth),
            nameFile.heightAnchor.constraint(equalToConstant: 30),
            
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            readyButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            readyButton.heightAnchor.constraint(equalToConstant: 30),
            readyButton.widthAnchor.constraint(equalToConstant: 80),
            
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            searchBar.topAnchor.constraint(equalTo: nameFile.bottomAnchor, constant: 16),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
