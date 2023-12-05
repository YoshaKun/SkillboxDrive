//
//  PublicFilesPresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 13.11.2023.
//

import Foundation

protocol OpenPublicFolderPresenterProtocol {
    
    func getModelData() -> LatestFiles
    
    func removePublishedData(
        path: String?,
        completion: @escaping () -> Void,
        errorHendler: @escaping () -> Void
    )
    
    func updateDataTableView(
        publicUrl: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void,
        noFiles: @escaping () -> Void,
        noInternet: @escaping () -> Void
    )
    
    func isPaginating() -> Bool
    
    func additionalGettingDataOfPublishedFolder (
        publicUrl: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    )
    
    func changePaginatingStateOnFalse()
}

final class OpenPublicFolderPresenter: OpenPublicFolderPresenterProtocol {
    
    private var model: OpenPublicFolderModel = OpenPublicFolderModel()
    
    func getModelData() -> LatestFiles {
        
        let data = model.modelData
        return data
    }
    
    func removePublishedData(
        path: String?,
        completion: @escaping () -> Void,
        errorHendler: @escaping () -> Void) {
        
        model.removePublishedFile(
            path: path,
            completion: completion,
            errorHendler: errorHendler
        )
    }
    
    func updateDataTableView(
        publicUrl: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void,
        noFiles: @escaping () -> Void,
        noInternet: @escaping () -> Void
    ) {
        
        model.getDataOfPublishedFolder(
            publicUrl: publicUrl,
            completion: completion,
            errorHandler: errorHandler,
            noFiles: noFiles,
            noInternet: noInternet
        )
    }
    
    func isPaginating() -> Bool {
        
        return model.isPaginating
    }
    
    func additionalGettingDataOfPublishedFolder (
        publicUrl: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    ) {
        
        model.additionalGettingDataOfPublishedFolder(
            publicUrl: publicUrl,
            completion: completion,
            errorHandler: errorHandler
        )
    }
    
    func changePaginatingStateOnFalse() {
        
        model.isPaginating = false
    }
}
