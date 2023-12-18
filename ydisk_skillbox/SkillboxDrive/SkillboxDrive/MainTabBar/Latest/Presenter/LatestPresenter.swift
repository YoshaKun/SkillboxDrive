//
//  LatestPresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 16.11.2023.
//

import Foundation

final class LatestPresenter {
    
    // MARK: - Public properties
    
    weak var output: LatestPresenterOutput?
    
    // MARK: - Private properties
    
    private let networkService: NetworkServiceLatestProtocol
    
    // MARK: - Initialization
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension LatestPresenter: LatestPresenterInput {
    
    func updateDataTableView() {
        networkService.updateDataTableView { [weak self] in
            self?.output?.didSuccessUpdateTableView()
        } noInternet: { [weak self] in
            self?.output?.noInternetUpdateTableView()
        }

    }
    
    func getModelData() -> LatestFiles {
        let data = networkService.getModelData()
        return data
    }
    
    func getFileFromPath(
        title: String?,
        created: String?,
        type: String?,
        file: String?,
        path: String?
    ) {
        networkService.getFileFromPath(
            path: path) { [weak self] in
                self?.output?.didSuccessGetFileFromPath(
                    title: title,
                    created: created,
                    type: type,
                    file: file,
                    path: path
                )
            } errorHandler: { [weak self] in
                self?.output?.didFailureGetFileFromPath()
            }
    }
    
    func additionalGetingLatestFiles() {
        networkService.additionalGetingLatestFiles { [weak self] in
            self?.output?.didSuccessAdditionalGettingFiles()
        } errorHandler: { [weak self] in
            self?.output?.didFailureAdditionalGettingFiles()
        }

    }
    
    func isPaginating() -> Bool {
        return networkService.isPaginating()
    }
    
    func changePaginatingStateOnFalse() {
        networkService.changePaginatingStateOnFalse()
    }
}
