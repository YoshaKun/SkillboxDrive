//
//  PublicFilesBuilder.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 20.12.2023.
//

import UIKit

enum PublicFilesBuilder {
    static func build() -> UIViewController {
        let networkService = NetworkService.shared
        let coreDataService = CoreDataManager.shared
        let presenter = PublicFilesPresenter(
            networkService: networkService,
            coreDataService: coreDataService
        )
        let viewController = PublicFilesViewController(presenter: presenter)
        presenter.output = viewController
        return viewController
    }
}
