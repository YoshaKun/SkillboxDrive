//
//  jhwelifhkjbegf.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 02.12.2023.
//

import Foundation

protocol AllFilesPresenterProtocol {
    
    func getModelData() -> LatestFiles
    func updateDataTableView (completion: @escaping () -> Void, errorHandler: @escaping () -> Void, noInternet: @escaping () -> Void)
    func isPaginating() -> Bool
    func additionalGetingAllFiles (completion: @escaping () -> Void, errorHandler: @escaping () -> Void)
    func changePaginatingStateOnFalse()
}

final class AllFilesPresenter: AllFilesPresenterProtocol {
    
    private var model: AllFilesModel = AllFilesModel()
    
    func getModelData() -> LatestFiles {
        
        let data = model.modelData
        if data.items!.isEmpty {
            print("сработал метод readPublicFilesRealm")
            return model.readPublicFilesRealm()
        }
        return data
    }
    
    func updateDataTableView (completion: @escaping () -> Void, errorHandler: @escaping () -> Void, noInternet: @escaping () -> Void) {
        
        model.getAllFiles(completion: completion, errorHandler: errorHandler, noInternet: noInternet)
    }
    
    func isPaginating() -> Bool {
        
        return model.isPaginating
    }
    
    func additionalGetingAllFiles (completion: @escaping () -> Void, errorHandler: @escaping () -> Void) {
        
        model.additionalGetingAllFiles(completion: completion, errorHandler: errorHandler)
    }
    
    func changePaginatingStateOnFalse() {
        model.isPaginating = false
    }
}
