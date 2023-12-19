//
//  AllFilesBuilder.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 19.12.2023.
//

import UIKit

enum AllFilesBuilder {
    static func build() -> UIViewController {
        let networkService = NetworkService.shared
        let presenter = AllFilesPresenter(networkService: networkService)
        let viewController = AllFilesViewController(presenter: presenter)

        presenter.output = viewController
        
        return viewController
    }
}
