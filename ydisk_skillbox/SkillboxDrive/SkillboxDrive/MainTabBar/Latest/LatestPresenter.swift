//
//  LatestPresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 16.11.2023.
//

import Foundation

protocol LatestPresenterProtocol {
    
    func updateDataTableView(completion: @escaping () -> Void)
    func getModelDataItemsCount() -> Int?
    func getModelData() -> LatestFiles
}

final class LatestPresenter: LatestPresenterProtocol {
    
    private var model: LatestModel = LatestModel()
    
    func updateDataTableView(completion: @escaping () -> Void) {
        
        model.getLatestFiles(completion: completion)
    }
    
    func getModelDataItemsCount() -> Int? {
        
        guard let data = model.modelData.items else { return 1 }
        let countOfItems = data.count
        return countOfItems
    }
    
    func getModelData() -> LatestFiles {
        
        let data = model.modelData
        return data
    }
}
