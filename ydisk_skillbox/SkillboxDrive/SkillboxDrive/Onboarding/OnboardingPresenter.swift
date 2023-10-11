//
//  FirstPresenter.swift
//  M22_MVP_proj
//
//  Created by Yosha Kun on 20.09.2023.
//

import Foundation
import UIKit

protocol OnboardingPresenterProtocol: AnyObject {
    
    func setView(_ view: OnboardingViewControllerProtocol)
    func numberOfItemsInSection(_ section: Int) -> Int
    func getModelArray(index: Int) -> OnboardingModel
    func transitionToLoginScreen()
}

final class OnboardingPresenter: OnboardingPresenterProtocol {
    
    private weak var view: OnboardingViewControllerProtocol?
    private var model: OnboardingData = OnboardingData()
    
    func setView(_ view: OnboardingViewControllerProtocol) {
        self.view = view
    }
    
    func transitionToLoginScreen() {
        let vc = LoginScreenViewController()
        vc.modalPresentationStyle = .fullScreen
        view?.presentNewController(vc: vc, anime: true)
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        
        model.onboardingArray.count
    }
    
    func getModelArray(index: Int) -> OnboardingModel {
        
        let memberOfArray = model.onboardingArray[index]
        return memberOfArray
    }
}
