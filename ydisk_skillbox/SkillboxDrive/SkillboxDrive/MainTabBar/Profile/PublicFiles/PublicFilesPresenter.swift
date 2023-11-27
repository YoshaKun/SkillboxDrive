//
//  PublicFilesPresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 13.11.2023.
//

import Foundation

protocol PublicFilesPresenterProtocol {
    
    func updateDataTableView(completion: @escaping () -> Void, errorHandler: @escaping () -> Void)
    func getModelDataItemsCount() -> Int?
    func getModelData() -> LatestFiles
    func removePublishedData(path: String?, completion: @escaping () -> Void)
    func fetchDataOfPublishedFolder(publicUrl: String?, completion: @escaping () -> Void)
}

final class PublicFilesPresenter: PublicFilesPresenterProtocol {
    
    private var model: PublicFilesModel = PublicFilesModel()
    
    func updateDataTableView(completion: @escaping () -> Void, errorHandler: @escaping () -> Void) {
        
        model.getPublishedFiles(completion: completion, errorHandler: errorHandler)
    }
    
    func getModelDataItemsCount() -> Int? {
        
        guard let data = model.modelData.items else { return 0 }
        let countOfItems = data.count
        return countOfItems
    }
    
    func getModelData() -> LatestFiles {
        
        let data = model.modelData
        return data
    }
    
    func removePublishedData(path: String?, completion: @escaping () -> Void) {
        
        model.removePublishedFile(path: path, completion: completion)
    }
    
    func fetchDataOfPublishedFolder(publicUrl: String?, completion: @escaping () -> Void) {
        
        model.getDataOfPublishedFolder(publicUrl: publicUrl, completion: completion)
    }
}
