//
//  FirstPresenter.swift
//  M22_MVP_proj
//
//  Created by Yosha Kun on 20.09.2023.
//

import Foundation
import UIKit

protocol OnboardingPresenterProtocol: AnyObject {
    
    func numberOfItemsInSection(_ section: Int) -> Int
    func getModelArray(index: Int) -> OnboardingModel
}

final class OnboardingPresenter: OnboardingPresenterProtocol {
    
    private var model: OnboardingData = OnboardingData()
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        
        model.onboardingArray.count
    }
    
    func getModelArray(index: Int) -> OnboardingModel {
        
        let memberOfArray = model.onboardingArray[index]
        return memberOfArray
    }
}
