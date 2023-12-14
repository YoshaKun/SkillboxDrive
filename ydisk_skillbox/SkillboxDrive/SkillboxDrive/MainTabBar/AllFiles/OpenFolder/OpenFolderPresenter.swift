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
    func determinationOfFileType(path: String) -> String
}

final class OpenFolderPresenter: OpenFolderPresenterProtocol {
    
    private var model: OpenFolderModel = OpenFolderModel()
    
    func getModelData() -> LatestFiles {
        let data = NetworkService.shared.modelDataAllOpenFolder
        return data
    }
    
    func updateDataTableView(
        path: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void,
        noInternet: @escaping () -> Void
    ) {
        NetworkService.shared.getAllFilesOpenFolder(
            path: path,
            completion: completion,
            errorHandler: errorHandler,
            noInternet: noInternet
        )
    }
    
    func isPaginating() -> Bool {
        
        return NetworkService.shared.isPaginatingAllOpenFolder
    }
    
    func additionalGettingFiles(
        path: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    ) {
        NetworkService.shared.additionalGettingAllFilesOpenFolder(
            path: path,
            completion: completion,
            errorHandler: errorHandler
        )
    }
    
    func changePaginatingStateOnFalse() {
        NetworkService.shared.isPaginatingAllOpenFolder = false
    }
    
    func determinationOfFileType(path: String) -> String {
        model.determinationOfFileType(path: path)
    }
}

