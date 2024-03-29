//
//  ProfileBuilder.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 19.12.2023.
//

import UIKit

enum ProfileBuilder {
    static func build() -> UIViewController {
        let networkService = NetworkService.shared
        let coreDataService = CoreDataManager.shared
        let presenter = ProfilePresenter(
            networkService: networkService,
            coreDataService: coreDataService
        )
        let viewController = ProfileViewController(presenter: presenter)
        presenter.output = viewController
        return viewController
    }
}
