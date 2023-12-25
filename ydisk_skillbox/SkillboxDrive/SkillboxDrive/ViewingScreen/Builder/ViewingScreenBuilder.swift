//
//  Builder.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 25.12.2023.
//

import UIKit

enum ViewingScreenBuilder {
    static func build(
        title: String?,
        created: String?,
        type: String?,
        file: String?,
        path: String?
    ) -> UIViewController {
        let networkService = NetworkService.shared
        let presenter = ViewingScreenPresenter(networkService: networkService)
        let viewController = ViewingScreenViewController(
            title: title,
            created: created,
            type: type,
            file: file,
            path: path,
            presenter: presenter
        )
        presenter.output = viewController
        return viewController
    }
}
