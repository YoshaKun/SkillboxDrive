//
//  jhwelifhkjbegf.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 02.12.2023.
//

import Foundation

protocol AllFilesPresenterProtocol {
    
    func getModelData() -> LatestFiles
    
    func updateDataTableView (
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void,
        noInternet: @escaping () -> Void
    )
    func isPaginating() -> Bool
    
    func additionalGetingAllFiles (
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    )
    func changePaginatingStateOnFalse()
    func determinationOfFileType(path: String) -> String
}

final class AllFilesPresenter: AllFilesPresenterProtocol {
    
    private var model: AllFilesModel = AllFilesModel()
    
    func getModelData() -> LatestFiles {
        let data = NetworkService.shared.modelDataAllFiles
        return data
    }
    
    func updateDataTableView (completion: @escaping () -> Void, 
                              errorHandler: @escaping () -> Void,
                              noInternet: @escaping () -> Void
    ) {
        NetworkService.shared.getAllFiles(
            completion: completion,
            errorHandler: errorHandler,
            noInternet: noInternet
        )
    }
    
    func isPaginating() -> Bool {
        
        return NetworkService.shared.isPaginatingAllFiles
    }
    
    func additionalGetingAllFiles (completion: @escaping () -> Void, 
                                   errorHandler: @escaping () -> Void
    ) {
        NetworkService.shared.additionalGetingAllFiles(
            completion: completion,
            errorHandler: errorHandler
        )
    }
    
    func changePaginatingStateOnFalse() {
        NetworkService.shared.isPaginatingAllFiles = false
    }
    
    func determinationOfFileType(path: String) -> String {
        model.determinationOfFileType(path: path)
    }
}
