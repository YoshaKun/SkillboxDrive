//
//  FirstPresenter.swift
//  M22_MVP_proj
//
//  Created by Yosha Kun on 20.09.2023.
//

import Foundation

final class OnboardingPresenter {
    
    // MARK: - Private properties

    private let onboardingData: OnboardingDataProtocol
    
    // MARK: - Initialization
    
    init(onboardingData: OnboardingDataProtocol) {
        self.onboardingData = onboardingData
    }
}

// MARK: - OnboardingPresenterInput

extension OnboardingPresenter: OnboardingPresenterInput {
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        onboardingData.getModel().count
    }
    
    func getModelArray(index: Int) -> OnboardingModel {
        let memberOfArray = onboardingData.getModel()[index]
        return memberOfArray
    }
}
