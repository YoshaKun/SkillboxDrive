//
//  OpenPublicFolderBuilder.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 20.12.2023.
//

import UIKit

enum OpenPublicFolderBuilder {
    static func build(
        title: String?,
        type: String?,
        publicUrl: String?,
        pathFolder: String?
    ) -> UIViewController {
        let networkService = NetworkService.shared
        let presenter = OpenPublicFolderPresenter(networkService: networkService)
        let viewController = OpenPublicFolderVC(
            title: title,
            type: type,
            publicUrl: publicUrl,
            pathFolder: pathFolder,
            presenter: presenter
        )
        presenter.output = viewController
        return viewController
    }
}
