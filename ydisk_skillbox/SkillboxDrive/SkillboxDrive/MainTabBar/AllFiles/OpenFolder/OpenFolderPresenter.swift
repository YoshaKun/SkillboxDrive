//
//  OpenFolderPresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 02.12.2023.
//

import Foundation

protocol OpenFolderPresenterProtocol {
    
    func getModelData() -> LatestFiles
    
    func updateDataTableView(
        path: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void,
        noInternet: @escaping () -> Void
    )
    
    func isPaginating() -> Bool
    
    func additionalGettingFiles(
        path: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    )
    
    func changePaginatingStateOnFalse()
}

final class OpenFolderPresenter: OpenFolderPresenterProtocol {
    
    private var model: OpenFolderModel = OpenFolderModel()
    
    func getModelData() -> LatestFiles {
        
        let data = model.modelData
        return data
    }
    
    func updateDataTableView(
        path: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void,
        noInternet: @escaping () -> Void
    ) {
        
        model.getAllFiles(
            path: path,
            completion: completion,
            errorHandler: errorHandler,
            noInternet: noInternet
        )
    }
    
    func isPaginating() -> Bool {
        
        return model.isPaginating
    }
    
    func additionalGettingFiles(
        path: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    ) {
        model.additionalGettingFiles(
            path: path,
            completion: completion,
            errorHandler: errorHandler
        )
    }
    
    func changePaginatingStateOnFalse() {
        
        model.isPaginating = false
    }
}

