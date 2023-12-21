//
//  PublicFilesPresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 13.11.2023.
//

import Foundation

final class OpenPublicFolderPresenter {
    
    // MARK: - Public properties
    
    weak var output: OpenPublicFolderPresenterOutput?
    
    // MARK: - Private
    
    private let networkService: NetworkServiceOpenPublicProtocol
    
    // MARK: - Initialization
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension OpenPublicFolderPresenter: OpenPublicFolderPresenterInput {
    
    func getModelData() -> LatestFilesModel {
        let data = networkService.gettingModelDataPublicOpen()
        return data
    }
    
    func removePublishedData(path: String?) {
        networkService.removePublishedData(
            path: path) { [weak self] in
                self?.output?.didSuccessRemovePublishedData()
            } errorHendler: { [weak self] in
                self?.output?.didFailureRemovePublishedData()
            }
    }
    
    func updateDataTableView(publicUrl: String?) {
        networkService.getDataOfOpenPublishedFolder(publicUrl: publicUrl) { [weak self] in
            self?.output?.didSuccessUpdateDataTableView()
        } errorHandler: { [weak self] in
            self?.output?.didFailureUpdateDataTableView()
        } noFiles: { [weak self] in
            self?.output?.noFilesUpdateDataTableView()
        } noInternet: { [weak self] in
            self?.output?.noInternetUpdateDataTableView()
        }

    }
    
    func isPaginating() -> Bool {
        return networkService.fetchPaginatingState()
    }
    
    func additionalGettingDataOfPublishedFolder (publicUrl: String?) {
        networkService.additionalGettingDataOfOpenPublishedFolder(publicUrl: publicUrl) { [weak self] in
            self?.output?.didSuccessAdditionalGettingData()
        } errorHandler: { [weak self] in
            self?.output?.didFailureAdditionalGettingData()
        }

    }
    
    func changePaginatingStateOnFalse() {
        networkService.changePaginatingOpenPublicStateToFalse()
    }
}
