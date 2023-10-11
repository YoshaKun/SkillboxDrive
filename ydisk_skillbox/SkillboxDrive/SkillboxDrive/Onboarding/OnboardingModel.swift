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

class OnboardingData {
    
    let onboardingArray: [OnboardingModel] = [
        OnboardingModel(image: OnboardingConstants.Image.onboarding1, description: OnboardingConstants.Text.textOnboarding1),
        OnboardingModel(image: OnboardingConstants.Image.onboarding2, description: OnboardingConstants.Text.textOnboarding2),
        OnboardingModel(image: OnboardingConstants.Image.onboarding3, description: OnboardingConstants.Text.textOnboarding3)]
}
