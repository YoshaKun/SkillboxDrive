//
//  MVPExamplePresenter.swift
//  SkillboxDrive
//
//  Created by Евгений Капанов on 14.12.2023.
//

final class MVPExamplePresenter {
    
    // MARK: - Public properties
    
    weak var output: MVPExamplePresenterOutput?
    
    // MARK: - Private
    
    private let networkService: NetworkService // Тип должен быть протоколом
    
    // MARK: - Initialization
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

// MARK: - MVPExamplePresenterInput

extension MVPExamplePresenter: MVPExamplePresenterInput {
    func updateDataTableView() {
        output?.startLoader()
        
        networkService.getLatestFiles(completion: { [weak self] in
            self?.output?.didSuccessUpdateDataTableView()
            self?.output?.hideLoader()
        }, noInternet: { [weak self] in
            self?.output?.didFailureUpdateDataTableView()
            self?.output?.hideLoader()
        })
    }
}
