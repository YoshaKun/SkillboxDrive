//
//  OnboardingConstants.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 10.10.2023.
//

import UIKit

enum OnboardingConstants {
    
    enum Image {
        static let onboarding1 = UIImage(named: "onboarding1")
        static let onboarding2 = UIImage(named: "onboarding2")
        static let onboarding3 = UIImage(named: "onboarding3")
    }
    
    enum Text {
        static let textOnboarding1 = "Теперь все ваши документы в одном месте"
        static let textOnboarding2 = "Доступ к файлам без интернета"
        static let textOnboarding3 = "Делитесь вашими файлами с другими"
    }
    
    enum Fonts {
        static var systemHeading: UIFont {
            UIFont.systemFont(ofSize: 30, weight: .semibold)
        }
        static var systemText: UIFont {
            UIFont.systemFont(ofSize: 16)
        }
    }
    
    enum Colors {
        static var blueSpecial: UIColor? {
            UIColor(named: "BlueSpecial")
        }
        static var graySpecial: UIColor? {
            UIColor(named: "GraySpecial")
        }
    }
}

