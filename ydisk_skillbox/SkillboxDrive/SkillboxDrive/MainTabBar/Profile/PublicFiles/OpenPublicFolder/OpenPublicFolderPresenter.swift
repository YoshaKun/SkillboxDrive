//
//  PublicFilesPresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 13.11.2023.
//

import Foundation

protocol OpenPublicFolderPresenterProtocol {
    
    func updateDataTableView(
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void,
        noInternet: @escaping () -> Void
    )
    
    func getModelData() -> LatestFiles
    
    func removePublishedData(
        path: String?,
        completion: @escaping () -> Void,
        errorHendler: @escaping () -> Void
    )
    
    func fetchDataOfPublishedFile(
        publicUrl: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void,
        noInternet: @escaping () -> Void
    )
    
    func fetchDataOfPublishedFolder (
        publicUrl: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void,
        noInternet: @escaping () -> Void
    )
}

final class OpenPublicFolderPresenter: OpenPublicFolderPresenterProtocol {
    
    private var model: OpenPublicFolderModel = OpenPublicFolderModel()
    
    func updateDataTableView(
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void,
        noInternet: @escaping () -> Void
    ) {
        
        model.getPublishedFiles(
            completion: completion,
            errorHandler: errorHandler,
            noInternet: noInternet
        )
    }
    
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
    
    func fetchDataOfPublishedFile(
        publicUrl: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void,
        noInternet: @escaping () -> Void
    ) {
        
        model.getDataOfPublishedFiles(
            publicUrl: publicUrl,
            completion: completion,
            errorHandler: errorHandler,
            noInternet: noInternet
        )
    }
    
    func fetchDataOfPublishedFolder(
        publicUrl: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void,
        noInternet: @escaping () -> Void
    ) {
        
        model.getDataOfPublishedFolder(
            publicUrl: publicUrl,
            completion: completion,
            errorHandler: errorHandler,
            noInternet: noInternet
        )
    }
}
