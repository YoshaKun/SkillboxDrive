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
    private let coreDataService: CoreDataAllFilesProtocol

    // MARK: - Initialization

    init(
        networkService: NetworkService,
        coreDataService: CoreDataManager
    ) {
        self.networkService = networkService
        self.coreDataService = coreDataService
    }
}

// MARK: - extension AllFilesPresenterInput

extension AllFilesPresenter: AllFilesPresenterInput {

    func getModelData() -> LatestFilesModel {
        return networkService.getModelDataAllFiles()
    }

    func fetchAllFilesModelFromCoreData() -> LatestFilesModel {
        print("сработал метод fetchProfileCoreData")
        return coreDataService.fetchAllFilesCoreData()
    }

    func updateDataTableView () {
        networkService.getAllFiles { [weak self] in
            self?.output?.didSuccessUpdateTableView()
            self?.coreDataService.deleteAllFilesFromCoreData()
            guard let modelData = self?.networkService.getModelDataAllFiles() else {
                print("error of save data to CoreData")
                return
            }
            self?.coreDataService.saveAllFilesOnCoreData(openList: modelData)
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
