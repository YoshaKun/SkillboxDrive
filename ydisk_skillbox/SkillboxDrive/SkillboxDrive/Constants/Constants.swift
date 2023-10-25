//
//  OnboardingConstants.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 10.10.2023.
//

import UIKit

enum Constants {
    
    enum Image {
        static let onboarding1 = UIImage(named: "onboarding1")
        static let onboarding2 = UIImage(named: "onboarding2")
        static let onboarding3 = UIImage(named: "onboarding3")
        static let logo1 = UIImage(named: "Logo")
        static let tabBar1 = UIImage(named: "ProfilePicture")
        static let tabBar2 = UIImage(named: "LatestPicture")
        static let tabBar3 = UIImage(named: "AllFilesPicture")
    }
    
    enum Text {
        static let onboarding1 = Bundle.main.localizedString(forKey: "onboarding1", value: "", table: "Localize")
        static let onboarding2 = Bundle.main.localizedString(forKey: "onboarding2", value: "", table: "Localize")
        static let onboarding3 = Bundle.main.localizedString(forKey: "onboarding3", value: "", table: "Localize")
        static let nextButton = Bundle.main.localizedString(forKey: "nextButton", value: "", table: "Localize")
        static let loginButton = Bundle.main.localizedString(forKey: "loginButton", value: "", table: "Localize")
        
        enum FirstVC {
            static let title = Bundle.main.localizedString(forKey: "FirstVC.title", value: "", table: "Localize")
        }
        
        enum SecondVC {
            static let title = Bundle.main.localizedString(forKey: "SecondVC.title", value: "", table: "Localize")
        }
        
        enum ThirdVC {
            static let title = Bundle.main.localizedString(forKey: "ThirdVC.title", value: "", table: "Localize")
        }
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

