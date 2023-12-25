//
//  RenameFileBuilder.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 25.12.2023.
//

import UIKit

enum RenameFileBuilder {
    static func build(
        nameFile: String?,
        path: String?
    ) -> UIViewController {
        let networkService = NetworkService.shared
        let presenter = RenameFilePresenter(networkService: networkService)
        let viewController = RenameFileVC(
            nameFile: nameFile,
            path: path,
            presenter: presenter
        )
        presenter.output = viewController
        return viewController
    }
}
