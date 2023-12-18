//
//  OnboardingPresenterInput.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 18.12.2023.
//

import Foundation

protocol OnboardingPresenterInput: AnyObject {
    func numberOfItemsInSection(_ section: Int) -> Int
    func getModelArray(index: Int) -> OnboardingModel
}
