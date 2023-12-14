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
    func determinationOfFileType(path: String) -> String
}

final class PublicFilesPresenter: PublicFilesPresenterProtocol {
    
    private var model: PublicFilesModel = PublicFilesModel()
    
    func updateDataTableView(
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void,
        noInternet: @escaping () -> Void
    ) {
        NetworkService.shared.getPublishedFiles(
            completion: completion,
            errorHandler: errorHandler,
            noInternet: noInternet
        )
    }
    
    func getModelData() -> LatestFiles {
        
        let data = NetworkService.shared.modelDataPublic
//        if ((data.items?.isEmpty) != nil) {
//            print("сработал метод readPublicFilesRealm")
//            return model.readPublicFilesRealm()
//        }
        return data
    }
    
    func removePublishedData(
        path: String?,
        completion: @escaping () -> Void,
        errorHendler: @escaping () -> Void
    ) {
        NetworkService.shared.removePublishedFile(
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
        NetworkService.shared.getDataOfPublishedFiles(
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
        NetworkService.shared.getDataOfPublishedFolder(
            publicUrl: publicUrl,
            completion: completion,
            errorHandler: errorHandler,
            noInternet: noInternet
        )
    }
    
    func isPaginating() -> Bool {
        return NetworkService.shared.isPaginatingPublic
    }
    
    func additionalGetingPublishedFiles (
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    ) {
        NetworkService.shared.additionalGetingPublishedFiles(
            completion: completion,
            errorHandler: errorHandler
        )
    }
    
    func changePaginatingStateOnFalse() {
        NetworkService.shared.isPaginatingPublic = false
    }
    
    func determinationOfFileType(path: String) -> String {
        model.determinationOfFileType(path: path)
    }
}
