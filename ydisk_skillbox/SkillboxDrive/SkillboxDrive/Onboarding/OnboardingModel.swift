//
//  OnboardingModel.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 05.10.2023.
//

import UIKit

struct OnboardingModel {
    
    let image: UIImage?
    let description: String?
}

final class OnboardingData {
    
    let onboardingArray: [OnboardingModel] = [
        OnboardingModel(image: Constants.Image.onboarding1, description: Constants.Text.onboarding1),
        OnboardingModel(image: Constants.Image.onboarding2, description: Constants.Text.onboarding2),
        OnboardingModel(image: Constants.Image.onboarding3, description: Constants.Text.onboarding3)]
}
