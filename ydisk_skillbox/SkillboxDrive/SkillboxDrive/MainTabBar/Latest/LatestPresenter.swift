//
//  LatestPresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 16.11.2023.
//

import Foundation

protocol LatestPresenterProtocol {
    
    func updateDataTableView(completion: @escaping () -> Void, noInternet: @escaping () -> Void)
    func getModelData() -> LatestFiles
    func getFileFromPath(path: String?, completion: @escaping () -> Void, errorHandler: @escaping () -> Void)
    func additionalGetingLatestFiles (completion: @escaping () -> Void, errorHandler: @escaping () -> Void)
    func isPaginating() -> Bool
    func changePaginatingStateOnFalse()
}

final class LatestPresenter: LatestPresenterProtocol {
    
    private var model: LatestModel = LatestModel()
    
    func updateDataTableView(completion: @escaping () -> Void, noInternet: @escaping () -> Void) {
        
        model.getLatestFiles(completion: completion, noInternet: noInternet)
    }
    
    func getModelData() -> LatestFiles {
        
        let data = model.modelData
        if data.items!.isEmpty {
            print("сработал метод readPublicFilesRealm")
            return model.readPublicFilesRealm()
        }
        return data
    }
    
    func getFileFromPath(path: String?, completion: @escaping () -> Void, errorHandler: @escaping () -> Void) {
        
        model.getFileFromPath(path: path, completion: completion, errorHandler: errorHandler)
    }
    
    func additionalGetingLatestFiles(completion: @escaping () -> Void, errorHandler: @escaping () -> Void) {
        
        model.additionalGetingLatestFiles(completion: completion, errorHandler: errorHandler)
    }
    
    func isPaginating() -> Bool {
        
        return model.isPaginating
    }
    
    func changePaginatingStateOnFalse() {
        model.isPaginating = false
    }
}
