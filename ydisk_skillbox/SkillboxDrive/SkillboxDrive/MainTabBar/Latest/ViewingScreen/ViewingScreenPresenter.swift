//
//  ViewingScreenPresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 20.11.2023.
//

import Foundation

protocol ViewingScreenPresenterProtocol {
    
    func getImage(urlStr: String, completion: @escaping (Data) -> Void)
}

final class ViewingScreenPresenter: ViewingScreenPresenterProtocol {
    
    private var model: ViewingScreenModel = ViewingScreenModel()
    
    func getImage(urlStr: String, completion: @escaping (Data) -> Void) {
        
        model.getImageForView(urlStr: urlStr, completion: completion)
    }
}
