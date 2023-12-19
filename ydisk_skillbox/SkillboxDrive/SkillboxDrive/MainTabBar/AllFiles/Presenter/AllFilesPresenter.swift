//
//  jhwelifhkjbegf.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 02.12.2023.
//

import Foundation

final class AllFilesPresenter {

    // MARK: - Public properties
    
    weak var output: AllFilesPresenterOutput?
    
    // MARK: - Private
    
    private let networkService: NetworkServiceAllFilesProtocol
    
    // MARK: - Initialization
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

// MARK: - extension AllFilesPresenterInput

extension AllFilesPresenter: AllFilesPresenterInput {
    
    func getModelData() -> LatestFiles {
        return networkService.getModelDataAllFiles()
    }
    
    func updateDataTableView () {
        networkService.getAllFiles { [weak self] in
            self?.output?.didSuccessUpdateTableView()
        } errorHandler: { [weak self] in
            self?.output?.didFailureUpdateTableView()
        } noInternet: { [weak self] in
            self?.output?.noInternetUpdateTableView()
        }
    }
    
    func isPaginating() -> Bool {
        
        return networkService.getBoolIsPaginating()
    }
    
    func additionalGetingAllFiles () {
        networkService.additionalGetingAllFiles { [weak self] in
            self?.output?.didSuccessAdditionalGetingAllFiles()
        } errorHandler: { [weak self] in
            self?.output?.didFailureAdditionalGetingAllFiles()
        }
    }
    
    func changePaginatingStateOnFalse() {
        networkService.changePaginatingStateToFalse()
    }
}
