//
//  SplashScreenViewController.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 11.10.2023.
//

import UIKit

final class LoginScreenViewController: UIViewController {

    private let presenter: LoginScreenPresenterInput
    private let logoImage = UIImageView()
    private let enterButton = UIButton()
    private let showOnbordButton = UIButton()

    // MARK: - Initialization
    init(presenter: LoginScreenPresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override methods

    override func viewDidLoad() {

        super.viewDidLoad()
        configureViews()
        configureConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // MARK: - Showing the Onboarding
        // Показываем Онборд новому пользователю 1 раз
        if Core.shared.isNewUser() {
            guard let newVC = didTapOnOnboardButton() else { return }
            present(newVC, animated: true)
        }
    }

    private func didTapOnOnboardButton() -> UIViewController? {

        let onboardVC = OnboardingBuilder.build()
        onboardVC.modalPresentationStyle = .fullScreen

        return onboardVC
    }

    private func configureViews() {

        view.backgroundColor = .systemBackground
        logoImage.image = Constants.Image.logo1
        logoImage.contentMode = .center

        enterButton.backgroundColor = Constants.Colors.blueSpecial
        enterButton.setTitle(Constants.Text.loginButton, for: .normal)
        enterButton.setTitleColor(.white, for: .normal)
        enterButton.layer.cornerRadius = 7
        enterButton.addTarget(self, action: #selector(didTapOnEnterButton), for: .touchUpInside)

        showOnbordButton.backgroundColor = Constants.Colors.blueSpecial
        showOnbordButton.setTitle(Constants.Text.OnboardButton, for: .normal)
        showOnbordButton.setTitleColor(.white, for: .normal)
        showOnbordButton.layer.cornerRadius = 7
        showOnbordButton.addTarget(self, action: #selector(didTappedOnOnboardButton), for: .touchUpInside)
    }

    @objc private func didTapOnEnterButton() {

        if Core.shared.isNewUser() {
            guard let newVC = didTapOnOnboardButton() else { return }
            present(newVC, animated: true)
        }
        updateData()
        guard let tabBarController = didTapOnButton() else { return }
        present(tabBarController, animated: true, completion: nil)
    }

    private func didTapOnButton() -> UITabBarController? {

        let tabBarVC = UITabBarController()
        let firstVC = UINavigationController(rootViewController: ProfileBuilder.build())
        let secondVC = UINavigationController(rootViewController: LatestBuilder.build())
        let thirdVC = UINavigationController(rootViewController: AllFilesBuilder.build())
        tabBarVC.setViewControllers([firstVC, secondVC, thirdVC], animated: false)
        tabBarVC.modalPresentationStyle = .fullScreen
        return tabBarVC
    }

    @objc private func didTappedOnOnboardButton() {

        guard let newVC = didTapOnOnboardButton() else { return }
        present(newVC, animated: true, completion: nil)
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
            showOnbordButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }

    private func updateData() {

        if Core.shared.isNewUser() {
            Core.shared.setIsNotNewUser()
            let requestTokenViewController = AuthViewController()
            requestTokenViewController.delegate = self
            present(requestTokenViewController, animated: true, completion: nil)
            return
        }
        guard !(UserDefaults.standard.string(forKey: Keys.apiToken)?.isEmpty ?? true) else {
            let requestTokenViewController = AuthViewController()
            requestTokenViewController.delegate = self
            present(requestTokenViewController, animated: true, completion: nil)
            return
        }
        print("\(String(describing: UserDefaults.standard.string(forKey: Keys.apiToken)))")
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
// устанавливаем в Юзер дефолтс что у нас уже Не новый пользователь
    func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
// устанавливаем в Юзер дефолтс что у нас Новый пользователь
    func setNewUser() {
        UserDefaults.standard.set(false, forKey: "isNewUser")
    }
}
