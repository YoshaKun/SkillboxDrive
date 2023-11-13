//
//  PublicFilesViewController.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 13.11.2023.
//

import Foundation
import UIKit

final class PublicFilesViewController: UIViewController {
    
    private let presenter: PublicFilesPresenterProtocol = PublicFilesPresenter()
    private var noFilesImageView = UIImageView()
    private var descriptionLabel = UILabel()
    private var backButton = UIBarButtonItem()
    private var updateButton = UIButton()
    private var noFilesView = UIView()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: CGRect(x: 150, y: 400, width: 140, height: 140))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNoFiViews()
        configureUIView()
        configureNavigationBar()
//        configureConstraints()
    }
    
    private func configureNoFiViews() {
        
        view.backgroundColor = .white
        
        noFilesView.addSubview(noFilesImageView)
        noFilesView.addSubview(descriptionLabel)
        noFilesView.addSubview(updateButton)
        
        let offsetForImage = view.frame.size.width / 2
        let offsetForDescription = view.frame.size.width / 4
        
        noFilesImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        
        noFilesImageView.image = Constants.Image.noFiles
        noFilesImageView.contentMode = .scaleAspectFit
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.contentMode = .scaleAspectFit
        descriptionLabel.text = Constants.Text.FirstVC.noFilesDescr
        
        updateButton.backgroundColor = Constants.Colors.pink
        updateButton.setTitle(Constants.Text.FirstVC.update, for: .normal)
        updateButton.setTitleColor(.black, for: .normal)
        updateButton.layer.cornerRadius = 7
        updateButton.addTarget(self, action: #selector(didTappedOnUpdateButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            noFilesImageView.centerXAnchor.constraint(equalTo: noFilesView.centerXAnchor),
            noFilesImageView.topAnchor.constraint(equalTo: noFilesView.topAnchor, constant: offsetForImage / 1.5),
            noFilesImageView.widthAnchor.constraint(equalToConstant: offsetForImage),
            noFilesImageView.heightAnchor.constraint(equalToConstant: offsetForImage),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: noFilesView.leadingAnchor, constant: offsetForDescription / 2),
            descriptionLabel.topAnchor.constraint(equalTo: noFilesImageView.bottomAnchor, constant: offsetForDescription / 3),
            descriptionLabel.trailingAnchor.constraint(equalTo: noFilesView.trailingAnchor, constant: -offsetForDescription / 2),
            
            updateButton.bottomAnchor.constraint(equalTo: noFilesView.bottomAnchor, constant: -40),
            updateButton.leadingAnchor.constraint(equalTo: noFilesView.leadingAnchor, constant: 27),
            updateButton.heightAnchor.constraint(equalToConstant: 50),
            updateButton.trailingAnchor.constraint(equalTo: noFilesView.trailingAnchor, constant: -27),
        ])
    }
    
    @objc private func didTappedOnUpdateButton() {
        
        self.noFilesView.removeFromSuperview()
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    private func configureUIView() {
        
        view.addSubview(noFilesView)
        noFilesView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noFilesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noFilesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            noFilesView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noFilesView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func configureNavigationBar() {
    
        backButton = UIBarButtonItem(
            image: Constants.Image.backArrow,
            style: .plain,
            target: self,
            action: #selector(didTappedOnBackButton)
        )
        backButton.tintColor = Constants.Colors.gray
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = Constants.Text.FirstVC.publicFilesTitle
    }
    
    @objc private func didTappedOnBackButton() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func configureConstraints() {
                
    }
    
}
