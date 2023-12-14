//
//  LatestPresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 16.11.2023.
//

import Foundation

protocol LatestPresenterProtocol {
    
    func updateDataTableView(
        completion: @escaping () -> Void,
        noInternet: @escaping () -> Void
    )
    func getModelData() -> LatestFiles
    func getFileFromPath(
        path: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    )
    func additionalGetingLatestFiles (
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    )
    func isPaginating() -> Bool
    func changePaginatingStateOnFalse()
    func determinationOfFileType(path: String) -> String
}

final class LatestPresenter: LatestPresenterProtocol {
    
    private var model: LatestModel = LatestModel()
    
    func updateDataTableView(
        completion: @escaping () -> Void,
        noInternet: @escaping () -> Void
    ) {
        NetworkService.shared.getLatestFiles(
            completion: completion,
            noInternet: noInternet
        )
    }
    
    func getModelData() -> LatestFiles {
        let data = NetworkService.shared.modelDataLatest
        return data
    }
    
    func getFileFromPath(
        path: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    ) {
        NetworkService.shared.getFileFromPath(
            path: path,
            completion: completion,
            errorHandler: errorHandler
        )
    }
    
    func additionalGetingLatestFiles(
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    ) {
        NetworkService.shared.additionalGetingLatestFiles(
            completion: completion,
            errorHandler: errorHandler
        )
    }
    
    func isPaginating() -> Bool {
        return NetworkService.shared.isPaginatingLatest
    }
    
    func changePaginatingStateOnFalse() {
        NetworkService.shared.isPaginatingLatest = false
    }
    
    func determinationOfFileType(path: String) -> String {
        model.determinationOfFileType(path: path)
    }
}
