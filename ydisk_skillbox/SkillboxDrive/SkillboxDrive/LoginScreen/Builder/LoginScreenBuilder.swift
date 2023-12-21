//
//  LoginScreenBuilder.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 21.12.2023.
//

import UIKit

enum LoginScreenBuilder {
    static func build() -> UIViewController {
        let presenter = LoginScreenPresenter()
        let viewController = LoginScreenViewController(presenter: presenter)
        return viewController
    }
}
