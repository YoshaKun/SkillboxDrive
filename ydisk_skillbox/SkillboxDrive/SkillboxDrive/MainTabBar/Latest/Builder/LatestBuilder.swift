//
//  LatestBuilder.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 18.12.2023.
//

import UIKit

enum LatestBuilder {
    static func build() -> UIViewController {
        let networkService = NetworkService.shared
        let presenter = LatestPresenter(networkService: networkService)
        let viewController = LatestViewController(presenter: presenter)
        presenter.output = viewController
        
        return viewController
    }
}
