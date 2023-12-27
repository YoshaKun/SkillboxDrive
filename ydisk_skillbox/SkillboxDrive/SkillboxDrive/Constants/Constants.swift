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
        static let menu = UIImage(named: "Menu")
        static let arrow = UIImage(named: "arrow")
        static let noFiles = UIImage(named: "NoFiles")
        static let backArrow = UIImage(named: "BackArrow")
        static let folder = UIImage(named: "Folder")
        static let editLogo = UIImage(named: "EditLogo")
        static let linkLogo = UIImage(named: "LinkLogo")
        static let trash = UIImage(named: "Trash")
    }

    enum Text {
        static let onboarding1 = Bundle.main.localizedString(forKey: "onboarding1", value: "", table: "Localize")
        static let onboarding2 = Bundle.main.localizedString(forKey: "onboarding2", value: "", table: "Localize")
        static let onboarding3 = Bundle.main.localizedString(forKey: "onboarding3", value: "", table: "Localize")
        static let nextButton = Bundle.main.localizedString(forKey: "nextButton", value: "", table: "Localize")
        static let loginButton = Bundle.main.localizedString(forKey: "loginButton", value: "", table: "Localize")
        static let OnboardButton = Bundle.main.localizedString(forKey: "OnboardButton", value: "", table: "Localize")
        static let gbMemory = Bundle.main.localizedString(forKey: "gb", value: "", table: "Localize")
        static let mbMemory = Bundle.main.localizedString(forKey: "mb", value: "", table: "Localize")
        static let kbMemory = Bundle.main.localizedString(forKey: "kb", value: "", table: "Localize")
        static let errorInternet = Bundle.main.localizedString(forKey: "errorInternet", value: "", table: "Localize")
        static let emptyFolder = Bundle.main.localizedString(forKey: "emptyFolder", value: "", table: "Localize")
        static let fileError = Bundle.main.localizedString(forKey: "fileError", value: "", table: "Localize")
    }

    enum FirstVC {
        static let title = Bundle.main.localizedString(forKey: "FirstVC.title", value: "", table: "Localize")
        static let cancel = Bundle.main.localizedString(forKey: "FirstVC.cancel", value: "", table: "Localize")
        static let logOut = Bundle.main.localizedString(forKey: "FirstVC.logOut", value: "", table: "Localize")
        static let alertTitle = Bundle.main.localizedString(forKey: "FirstVC.alertTitle", value: "", table: "Localize")
        static let alertMessage = Bundle.main.localizedString(forKey: "FirstVC.alertMessage", value: "", table: "Localize")
        static let alertYes = Bundle.main.localizedString(forKey: "FirstVC.alertYes", value: "", table: "Localize")
        static let alertNo = Bundle.main.localizedString(forKey: "FirstVC.alertNo", value: "", table: "Localize")
        static let gbFilled = Bundle.main.localizedString(forKey: "FirstVC.gbFilled", value: "", table: "Localize")
        static let gbRemains = Bundle.main.localizedString(forKey: "FirstVC.gbRemains", value: "", table: "Localize")
        static let publicFiles = Bundle.main.localizedString(forKey: "FirstVC.publicFiles", value: "", table: "Localize")
        static let publicFilesTitle = Bundle.main.localizedString(forKey: "FirstVC.publicFilesTitle", value: "", table: "Localize")
        static let noFilesDescr = Bundle.main.localizedString(forKey: "FirstVC.noFilesDescr", value: "", table: "Localize")
        static let update = Bundle.main.localizedString(forKey: "FirstVC.update", value: "", table: "Localize")
        static let removePost = Bundle.main.localizedString(forKey: "FirstVC.removePost", value: "", table: "Localize")
    }

    enum SecondVC {
        static let title = Bundle.main.localizedString(forKey: "SecondVC.title", value: "", table: "Localize")
        static let deleteMessage = Bundle.main.localizedString(forKey: "SecondVC.deleteMessage", value: "", table: "Localize")
        static let delete = Bundle.main.localizedString(forKey: "SecondVC.delete", value: "", table: "Localize")
        static let shareMessage = Bundle.main.localizedString(forKey: "SecondVC.shareMessage", value: "", table: "Localize")
        static let shareFile = Bundle.main.localizedString(forKey: "SecondVC.shareFile", value: "", table: "Localize")
        static let shareLink = Bundle.main.localizedString(forKey: "SecondVC.shareLink", value: "", table: "Localize")
        static let ready = Bundle.main.localizedString(forKey: "SecondVC.ready", value: "", table: "Localize")
        static let rename = Bundle.main.localizedString(forKey: "SecondVC.rename", value: "", table: "Localize")
    }

    enum ThirdVC {
        static let title = Bundle.main.localizedString(forKey: "ThirdVC.title", value: "", table: "Localize")
    }

    enum Fonts {
        static var systemHeading: UIFont {
            UIFont.systemFont(ofSize: 30, weight: .semibold)
        }
        static var systemText: UIFont {
            UIFont.systemFont(ofSize: 16)
        }
        static var graphik: UIFont {
            UIFont(name: "Graphik", size: 30) ?? UIFont.systemFont(ofSize: 16)
        }
    }

    enum Colors {
        static var blueSpecial: UIColor? {
            UIColor(named: "BlueSpecial")
        }
        static var graySpecial: UIColor? {
            UIColor(named: "GraySpecial")
        }
        static var gray: UIColor? {
            UIColor(named: "Gray")
        }
        static var pink: UIColor? {
            UIColor(named: "Pink")
        }
        static var red: UIColor? {
            UIColor(named: "Red")
        }
    }
}
