//
//  ViewingScreenPresenterOutput.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 25.12.2023.
//

import Foundation

protocol ViewingScreenPresenterOutput: AnyObject {
    func didSuccessGettingImage(data: Data)
    func didSuccessGettingLink()
    func didSuccessDeleting()
}
