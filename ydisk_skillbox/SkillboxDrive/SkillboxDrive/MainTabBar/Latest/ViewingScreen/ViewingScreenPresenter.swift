//
//  ViewingScreenPresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 20.11.2023.
//

import Foundation

protocol ViewingScreenPresenterProtocol {
    
    func getImage(urlStr: String, completion: @escaping (Data) -> Void)
    func delete(path: String?, completion: @escaping () -> Void)
    func getLinkFile(path: String?, completion: @escaping () -> Void)
}

final class ViewingScreenPresenter: ViewingScreenPresenterProtocol {
    
    private var model: ViewingScreenModel = ViewingScreenModel()
    
    func getImage(urlStr: String, completion: @escaping (Data) -> Void) {
        
        model.getImageForView(urlStr: urlStr, completion: completion)
    }
    
    func delete(path: String?, completion: @escaping () -> Void) {
        
        model.deleteFile(path: path, completion: completion)
    }
    
    func getLinkFile(path: String?, completion: @escaping () -> Void) {
        
        model.getLinkFile(path: path, completion: completion)
    }
}
