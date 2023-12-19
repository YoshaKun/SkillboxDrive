//
//  OpenFolderPresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 02.12.2023.
//

import Foundation

final class OpenFolderPresenter {
    
    // MARK: - Public properties
    
    weak var output: OpenFolderPresenterOutput?
    
    // MARK: - Private
    
    private let networkService: NetworkServiceAllOpenFolderProtocol
    
    // MARK: - Initialization
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

// MARK: - extension OpenFolderPresenterProtocol

extension OpenFolderPresenter: OpenFolderPresenterInput {
    
    func getModelData() -> LatestFiles {
        return networkService.getModelDataAllFilesOpenFolder()
    }
    
    func updateDataTableView(path: String?) {
        networkService.getAllFilesOpenFolder(
            path: path) { [weak self] in
                self?.output?.didSuccessUpdateTableView()
            } errorHandler: { [weak self] in
                self?.output?.didFailureUpdateTableView()
            } noInternet: { [weak self] in
                self?.output?.noInternetUpdateTableView()
            }
    }
    
    func isPaginatingOpenFolder() -> Bool {
        return networkService.gettingIsPaginatingAllOpenFolder()
    }
    
    func additionalGettingFiles(path: String?) {
        networkService.additionalGettingAllFilesOpenFolder(
            path: path) { [weak self] in
                self?.output?.didSuccessAdditionalGetting()
            } errorHandler: { [weak self] in
                self?.output?.didFailureAdditionalGetting()
            }
    }
    
    func changePaginatingStateOnFalse() {
        networkService.changePaginatingStateAllOpenFolderOnFalse()
    }
}

