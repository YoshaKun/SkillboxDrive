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
    private let coreDataService: CoreDataPublicFilesProtocol

    // MARK: - Initialization

    init(
        networkService: NetworkService,
        coreDataService: CoreDataManager
    ) {
        self.networkService = networkService
        self.coreDataService = coreDataService
    }
}

extension PublicFilesPresenter: PublicFilesPresenterInput {

    func updateDataTableView() {
        networkService.getPublishedFiles { [weak self] in
            self?.output?.didSuccessGettingPublishedFiles()
            self?.coreDataService.deletePublicFilesFromCoreData()
            guard let modelData = self?.networkService.getModalDataPublic() else {
                print("error of save data to CoreData")
                return
            }
            self?.coreDataService.saveOnCoreData(publicList: modelData)
        } errorHandler: { [weak self] in
            self?.output?.didFailureGettingPublishedFiles()
        } noInternet: { [weak self] in
            self?.output?.noInternetGettingPublishedFiles()
        }
    }

    func getModelData() -> LatestFilesModel {
        let data = networkService.getModalDataPublic()
        return data
    }

    func fetchPublicFilesModelFromCoreData() -> LatestFilesModel {
        return coreDataService.fetchPublicFilesCoreData()
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
