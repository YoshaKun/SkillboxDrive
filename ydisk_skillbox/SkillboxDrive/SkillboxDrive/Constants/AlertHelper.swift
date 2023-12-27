//
//  AlertHelper.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 27.12.2023.
//
import UIKit

final class AlertHelper {

    static func showAlert(withMessage message: String) {
        UIViewController.getTopViewController { topViewController in
            if let controller = topViewController {
                let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                controller.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension UIViewController {

    static func getTopViewController(completion: @escaping (UIViewController?) -> Void) {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
                completion(nil)
                return
            }
            var topViewController = rootViewController
            while let presentedViewController = topViewController.presentedViewController {
                topViewController = presentedViewController
            }
            completion(topViewController)
        }
    }
}
