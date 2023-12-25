//
//  OnboardingBuilder.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 18.12.2023.
//

import UIKit

enum OnboardingBuilder {
    static func build() -> UIViewController {
        let onboardingData = OnboardingData()
        let presenter = OnboardingPresenter(onboardingData: onboardingData)
        let viewController = OnboardingViewController(presenter: presenter)
        return viewController
    }
}
