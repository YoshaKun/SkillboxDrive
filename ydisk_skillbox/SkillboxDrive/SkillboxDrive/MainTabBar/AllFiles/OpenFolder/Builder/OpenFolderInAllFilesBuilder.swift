//
//  OpenFolderInAllFilesBuilder.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 19.12.2023.
//

import UIKit

enum OpenFolderInAllFilesBuilder {
    static func build(
        title: String?,
        type: String?,
        pathFolder: String?
    ) -> UIViewController {
        let networkService = NetworkService.shared
        let presenter = OpenFolderPresenter(networkService: networkService)
        let viewController = OpenFolderVC(
            title: title,
            type: type,
            pathFolder: pathFolder,
            presenter: presenter
        )
        presenter.output = viewController
        return viewController
    }
}
