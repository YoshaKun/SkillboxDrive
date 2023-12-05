//
//  PublicFilesPresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 13.11.2023.
//

import Foundation

protocol PublicFilesPresenterProtocol {
    
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
    
    func isPaginating() -> Bool
    
    func additionalGetingPublishedFiles (
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    )
    
    func changePaginatingStateOnFalse()
}

final class PublicFilesPresenter: PublicFilesPresenterProtocol {
    
    private var model: PublicFilesModel = PublicFilesModel()
    
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
        if ((data.items?.isEmpty) != nil) {
            print("сработал метод readPublicFilesRealm")
            return model.readPublicFilesRealm()
        }
        return data
    }
    
    func removePublishedData(
        path: String?,
        completion: @escaping () -> Void,
        errorHendler: @escaping () -> Void
    ) {
        
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
    
    func isPaginating() -> Bool {
        
        return model.isPaginating 
    }
    
    func additionalGetingPublishedFiles (
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    ) {
        
        model.additionalGetingPublishedFiles(
            completion: completion,
            errorHandler: errorHandler
        )
    }
    
    func changePaginatingStateOnFalse() {
        model.isPaginating = false
    }
    
}
