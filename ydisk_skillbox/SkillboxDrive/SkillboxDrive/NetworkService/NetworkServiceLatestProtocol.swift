//
//  NetworkServiceLatestProtocol.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 18.12.2023.
//

import Foundation

// MARK: - NetworkServiceLatestProtocol

protocol NetworkServiceLatestProtocol: AnyObject {
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
    func additionalGetingLatestFiles(
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    )
    func isPaginating() -> Bool
    func changePaginatingStateOnFalse()
}

// MARK: - extension NetworkService

extension NetworkService: NetworkServiceLatestProtocol {
    
    func updateDataTableView(completion: @escaping () -> Void, noInternet: @escaping () -> Void) {
        getLatestFiles(completion: completion, noInternet: noInternet)
    }
    
    func getModelData() -> LatestFiles {
        return modelDataLatest
    }
    
    func getFileFromPath(
        path: String?,
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    ) {
        getFileFromPathOnLatestScreen(
            path: path,
            completion: completion,
            errorHandler: errorHandler
        )
    }
    
    func additionalGetingLatestFiles(
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    ) {
        additionalGetingLatestFilesOnLatestScreen(
            completion: completion,
            errorHandler: errorHandler
        )
    }
    
    func isPaginating() -> Bool {
        return isPaginatingLatest
    }
    
    func changePaginatingStateOnFalse() {
        isPaginatingLatest = false
    }
}
