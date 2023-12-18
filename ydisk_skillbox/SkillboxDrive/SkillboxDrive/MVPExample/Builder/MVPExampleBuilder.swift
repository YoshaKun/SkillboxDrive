//
//  MVPExampleBuilder.swift
//  SkillboxDrive
//
//  Created by Евгений Капанов on 14.12.2023.
//

import UIKit

enum MVPExampleBuilder {
    static func build() -> UIViewController {
        let networkService = NetworkService.shared
        let presenter = MVPExamplePresenter(networkService: networkService)
        let viewController = MVPExampleViewController(presenter: presenter)

        presenter.output = viewController
        
        return viewController
    }
}
