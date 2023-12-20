//
//  PublicFilesPresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 13.11.2023.
//

import Foundation

final class PublicFilesPresenter {
    
    // MARK: - Public properties
    
    weak var output: PublicFilesPresenterOutput?
    
    // MARK: - Private
    
    private let networkService: NetworkServicePublicFilesProtocol
    
    // MARK: - Initialization
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension PublicFilesPresenter: PublicFilesPresenterInput {
    
    func updateDataTableView() {
        networkService.getPublishedFiles { [weak self] in
            self?.output?.didSuccessGettingPublishedFiles()
        } errorHandler: { [weak self] in
            self?.output?.didFailureGettingPublishedFiles()
        } noInternet: { [weak self] in
            self?.output?.noInternetGettingPublishedFiles()
        }
    }
    
    func getModelData() -> LatestFiles {
        
        let data = networkService.getModalDataPublic()
//        if ((data.items?.isEmpty) != nil) {
//            print("сработал метод readPublicFilesRealm")
//            return model.readPublicFilesRealm()
//        }
        return data
    }
    
    func removePublishedData(path: String?) {
        networkService.removePublishedFile(
            path: path) { [weak self] in
                self?.output?.didSuccessRemovePublishedFile()
            } errorHendler: { [weak self] in
                self?.output?.didFailureRemovePublishedFile()
            }
    }
    
    func isPaginating() -> Bool {
        return networkService.getStateOfPaginatingPublic()
    }
    
    func additionalGetingPublishedFiles () {
        networkService.additionalGetingPublishedFiles { [weak self] in
            self?.output?.didSuccessAdditionalPublishedFiles()
        } errorHandler: { [weak self] in
            self?.output?.didFailureAdditionalPublishedFiles()
        }
    }
    
    func changePaginatingStateOnFalse() {
        networkService.changePaginatingPublicStateToFalse()
    }
}
