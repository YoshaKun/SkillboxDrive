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
    private let coreDataService: CoreDataLatestProtocol

    // MARK: - Initialization

    init(
        networkService: NetworkService,
        coreDataService: CoreDataManager
    ) {
        self.networkService = networkService
        self.coreDataService = coreDataService
    }
}

extension LatestPresenter: LatestPresenterInput {

    func updateDataTableView() {
        networkService.getLatestFiles { [weak self] in
            self?.output?.didSuccessUpdateTableView()
            self?.coreDataService.deleteLatestFilesFromCoreData()
            guard let modelData = self?.networkService.getModelData() else {
                print("error of save data to CoreData")
                return
            }
            self?.coreDataService.saveLatestFilesOnCoreData(openList: modelData)
        } noInternet: { [weak self] in
            self?.output?.noInternetUpdateTableView()
        }
    }

    func getModelData() -> LatestFilesModel {
        let data = networkService.getModelData()
        return data
    }
    
    func fetchLatestModelFromCoreData() -> LatestFilesModel {
        print("сработал метод fetchProfileCoreData")
        return coreDataService.fetchLatestFilesCoreData()
    }

    func getFileFromPath(
        title: String?,
        created: String?,
        type: String?,
        file: String?,
        path: String?
    ) {
        networkService.getFileFromPathOnLatestScreen(
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
        networkService.additionalGetingLatestFilesOnLatestScreen { [weak self] in
            self?.output?.didSuccessAdditionalGettingFiles()
        } errorHandler: { [weak self] in
            self?.output?.didFailureAdditionalGettingFiles()
        }
    }

    func isPaginating() -> Bool {
        return networkService.isPaginatingLatestFiles()
    }

    func changePaginatingStateOnFalse() {
        networkService.changePaginatingStateOnFalse()
    }
}
