//
//  ViewingScreenViewController.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 20.11.2023.
//

import Foundation
import UIKit

final class ViewingScreenViewController: UIViewController {
    
    private let presenter: ViewingScreenPresenterProtocol = ViewingScreenPresenter()
    private var fileView = UIView()
    private var backButton = UIButton()
    private var editButton = UIButton()
    private var sendLinkButton = UIButton()
    private var trashButton = UIButton()
    private var activityIndicator = UIActivityIndicatorView()
    private var activityIndicatorView = UIView()
    private var titleFile = UILabel()
    private var dateOfCreated = UILabel()
    private var titleStackView = UIStackView()
    private var imageView = UIImageView()
    
    private var fileStr: String?
    private var createdDate: String?
    
    init(title: String?,
         created: String?,
         urlStr: String?
        ) {
        self.titleFile.text = title
        self.createdDate = created
        self.fileStr = urlStr
     
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        configureViews()
        configureConstraints()
        confugureGestureRecognizers()
        configureFileView()
        
    }
    
    private func confugureGestureRecognizers() {
        
        let panRecognazer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGest))
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapGest))
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGest))
        
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        fileView.addGestureRecognizer(panRecognazer)
        fileView.addGestureRecognizer(doubleTapRecognizer)
        fileView.addGestureRecognizer(tapRecognizer)
        fileView.isUserInteractionEnabled = true
    }
    
    @objc private func handlePanGest(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: fileView)
        if let view = recognizer.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @objc private func handleDoubleTapGest(recognizer: UITapGestureRecognizer) {
        
        print("double tap")
        guard let targetView = recognizer.view else { return }
        targetView.transform = CGAffineTransform.identity
        targetView.center = self.view.center
    }
    
    @objc private func handleTapGest(recognizer: UITapGestureRecognizer) {
        
        print("one tap")
        
        let x = CGFloat(2)
        let y = CGFloat(2)
        
        fileView.transform = CGAffineTransform(scaleX: x, y: y)
    }
    
    // MARK: - Configure FileView
    private func configureFileView() {
        
        guard let fileStr = fileStr else {
            print("error FileStr")
            return
        }
        presenter.getImage(urlStr: fileStr) { data in
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
        }
        
        imageView.contentMode = .scaleAspectFit
    }
    
    private func configureViews() {
    
        backButton.setImage(Constants.Image.backArrow, for: .normal)
        backButton.addTarget(self, action: #selector(didTapOnBackButton), for: .touchUpInside)
        
        editButton.setImage(Constants.Image.editLogo, for: .normal)
        editButton.addTarget(self, action: #selector(didTapOnEditButton), for: .touchUpInside)
        
        sendLinkButton.setImage(Constants.Image.linkLogo, for: .normal)
        sendLinkButton.addTarget(self, action: #selector(didTapOnSendLinkButton), for: .touchUpInside)
        
        trashButton.setImage(Constants.Image.trash, for: .normal)
        trashButton.addTarget(self, action: #selector(didTapOnTrashButton), for: .touchUpInside)
        
        titleFile.font = .systemFont(ofSize: 17, weight: .regular)
        titleFile.textColor = .white
        
        dateOfCreated.font = .systemFont(ofSize: 13, weight: .regular)
        dateOfCreated.textColor = Constants.Colors.gray
        dateOfCreated.text = parseDate(createdDate ?? "00.00.00 00:00")
        
        titleStackView.axis = .vertical
        titleStackView.alignment = .center
        titleStackView.spacing = 8
    }
    
    @objc private func didTapOnBackButton() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapOnEditButton() {
        
        print("Сработа метод didTappedOnEditButton")
    }
    
    @objc private func didTapOnSendLinkButton() {
        
        print("Сработа метод didTapOnSendLinkButton")
    }
    
    @objc private func didTapOnTrashButton() {
        
        print("Сработа метод didTapOnTrashButton")
    }
    
    private func configureConstraints() {
        
        let offsetWidth = view.frame.size.width / 2
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        fileView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        titleFile.translatesAutoresizingMaskIntoConstraints = false
        dateOfCreated.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        sendLinkButton.translatesAutoresizingMaskIntoConstraints = false
        trashButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(fileView)
        view.addSubview(backButton)
        view.addSubview(titleStackView)
        view.addSubview(editButton)
        view.addSubview(sendLinkButton)
        view.addSubview(trashButton)
        titleStackView.addArrangedSubview(titleFile)
        titleStackView.addArrangedSubview(dateOfCreated)
        
        fileView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            fileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            fileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            fileView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            fileView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            
            titleStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleStackView.widthAnchor.constraint(equalToConstant: offsetWidth),
            titleStackView.heightAnchor.constraint(equalToConstant: 40),
            
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            editButton.heightAnchor.constraint(equalToConstant: 30),
            editButton.widthAnchor.constraint(equalToConstant: 30),
            
            sendLinkButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 54),
            sendLinkButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            sendLinkButton.heightAnchor.constraint(equalToConstant: 30),
            sendLinkButton.widthAnchor.constraint(equalToConstant: 30),
            
            trashButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -54),
            trashButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            trashButton.heightAnchor.constraint(equalToConstant: 30),
            trashButton.widthAnchor.constraint(equalToConstant: 30),
            
            imageView.leadingAnchor.constraint(equalTo: fileView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: fileView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: fileView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: fileView.bottomAnchor),
        ])
    }
    
    // MARK: - ParseDate
    private func parseDate(_ str: String) -> String {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormat.date(from: str) ?? Date()
        dateFormat.locale = Locale(identifier: "ru_RU")
        dateFormat.dateStyle = .short
        dateFormat.timeStyle = .short
        return dateFormat.string(from: date)
    }
}
