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
    func determinationOfFileType(path: String) -> String
}

final class OpenPublicFolderPresenter: OpenPublicFolderPresenterProtocol {
    
    private var model: OpenPublicFolderModel = OpenPublicFolderModel()
    
    func getModelData() -> LatestFiles {
        let data = NetworkService.shared.modelDataPublicOpen
        return data
    }
    
    func removePublishedData(
        path: String?,
        completion: @escaping () -> Void,
        errorHendler: @escaping () -> Void) {
            NetworkService.shared.removePublishedFile(
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
        NetworkService.shared.getDataOfOpenPublishedFolder(
            publicUrl: publicUrl,
            completion: completion,
            errorHandler: errorHandler,
            noFiles: noFiles,
            noInternet: noInternet
        )
    }
    
    func isPaginating() -> Bool {
        return NetworkService.shared.isPaginatingPublicOpen
    }
    
    func additionalGettingDataOfPublishedFolder (
        publicUrl: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    ) {
        NetworkService.shared.additionalGettingDataOfOpenPublishedFolder(
            publicUrl: publicUrl,
            completion: completion,
            errorHandler: errorHandler
        )
    }
    
    func changePaginatingStateOnFalse() {
        NetworkService.shared.isPaginatingPublicOpen = false
    }
    
    func determinationOfFileType(path: String) -> String {
        model.determinationOfFileType(path: path)
    }
}
