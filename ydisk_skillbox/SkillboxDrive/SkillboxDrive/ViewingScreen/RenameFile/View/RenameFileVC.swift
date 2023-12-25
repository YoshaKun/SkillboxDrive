//
//  RenameFileVC.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 25.11.2023.
//

import UIKit

final class RenameFileVC: UIViewController {

    // MARK: - Private constants
    private let presenter: RenameFilePresenterInput
    private let backButton = UIButton()
    private let titleScreen = UILabel()
    private let readyButton = UIButton()
    private var searchBar = UISearchBar()
    private var fullNameFile = String()
    private var typeFile = String()
    private var initialPath = String()
    private var activityIndicator = UIActivityIndicatorView()
    private var activityIndicatorView = UIView()

    // MARK: - Initialization
    init(
        nameFile: String?,
        path: String?,
        presenter: RenameFilePresenterInput
    ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        guard let name = nameFile else { return }
        guard let path = path else { return }
        self.fullNameFile = name
        self.initialPath = path
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureConstraints()
    }

    // MARK: - Separation name of the file on (Name) and (dot Type)
    private func separationNameAndType(name: String) -> String {

        let index = name.lastIndex(of: ".") ?? name.endIndex
        let fileType = name[index ..< name.endIndex]
        let onlyName = name[..<index]
        let name = String(onlyName)
        typeFile = String(fileType)
        return name
    }

    private func createNewPathOfNewNameFile(initPath: String?, newName: String?, type: String) -> String {

        guard let newName = newName else {
            return initialPath
        }
        if newName == "" {
            return initialPath
        }
        guard let path = initPath else {
            return initialPath
        }
        let newFullName = newName + type
        let slash = "/"
        let index = path.lastIndex(of: "/") ?? path.endIndex
        let base = path[..<index]
        let baseOfPath = String(base)
        let newPath = baseOfPath + slash + newFullName
        return newPath
    }

    // MARK: - Configure Views
    private func configureViews() {

        view.backgroundColor = .white

        backButton.setImage(Constants.Image.backArrow, for: .normal)
        backButton.addTarget(self, action: #selector(didTapOnBackButton), for: .touchUpInside)

        titleScreen.font = .systemFont(ofSize: 17, weight: .semibold)
        titleScreen.textColor = .black
        titleScreen.textAlignment = .center
        titleScreen.text = Constants.Text.SecondVC.rename

        readyButton.setTitle(Constants.Text.SecondVC.ready, for: .normal)
        readyButton.setTitleColor(Constants.Colors.blueSpecial, for: .normal)
        readyButton.addTarget(self, action: #selector(didTapOnReadyButton), for: .touchUpInside)

        searchBar.placeholder = "Enter some letters"
        searchBar.layer.cornerRadius = 10
        searchBar.searchTextField.borderStyle = .none
        searchBar.text = separationNameAndType(name: fullNameFile)

        activityIndicatorView.backgroundColor = .white
    }

    // MARK: - ActivityIndicatorView
    private func configureActivityIndicatorView() {

        view.addSubview(activityIndicatorView)
        activityIndicatorView.addSubview(activityIndicator)

        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()

        NSLayoutConstraint.activate([
            activityIndicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            activityIndicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicatorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: activityIndicatorView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: activityIndicatorView.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func didTapOnReadyButton() {

        guard let name = searchBar.text else { return }
        configureActivityIndicatorView()
        let newPath = createNewPathOfNewNameFile(initPath: initialPath, newName: name, type: typeFile)
        presenter.renameFile(from: initialPath, path: newPath)
    }

    @objc private func didTapOnBackButton() {

        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Configure Constraints

    private func configureConstraints() {

        let offsetWidth = view.frame.size.width / 2

        backButton.translatesAutoresizingMaskIntoConstraints = false
        titleScreen.translatesAutoresizingMaskIntoConstraints = false
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(backButton)
        view.addSubview(titleScreen)
        view.addSubview(readyButton)
        view.addSubview(searchBar)

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            backButton.widthAnchor.constraint(equalToConstant: 30),

            titleScreen.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleScreen.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleScreen.widthAnchor.constraint(equalToConstant: offsetWidth),
            titleScreen.heightAnchor.constraint(equalToConstant: 30),

            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            readyButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            readyButton.heightAnchor.constraint(equalToConstant: 30),
            readyButton.widthAnchor.constraint(equalToConstant: 80),

            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            searchBar.topAnchor.constraint(equalTo: titleScreen.bottomAnchor, constant: 16),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

extension RenameFileVC: RenameFilePresenterOutput {

    func didSuccessRenameFile() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.activityIndicatorView.removeFromSuperview()
            self?.dismiss(animated: true)
        }
    }
}
