//
//  PublicFilesPresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 13.11.2023.
//

import Foundation

protocol PublicFilesPresenterProtocol {
    
    func updateDataTableView(completion: @escaping () -> Void, errorHandler: @escaping () -> Void, noInternet: @escaping () -> Void)
    func getModelData() -> LatestFiles
    func removePublishedData(path: String?, completion: @escaping () -> Void)
    func fetchDataOfPublishedFolder(publicUrl: String?, completion: @escaping () -> Void)
}

final class PublicFilesPresenter: PublicFilesPresenterProtocol {
    
    private var model: PublicFilesModel = PublicFilesModel()
    
    func updateDataTableView(completion: @escaping () -> Void, errorHandler: @escaping () -> Void, noInternet: @escaping () -> Void) {
        
        model.getPublishedFiles(completion: completion, errorHandler: errorHandler, noInternet: noInternet)
    }
    
    func getModelData() -> LatestFiles {
        
        let data = model.modelData
        if data.items!.isEmpty {
            print("сработал метод readPublicFilesRealm")
            return model.readPublicFilesRealm()
        }
        return data
    }
    
    func removePublishedData(path: String?, completion: @escaping () -> Void) {
        
        model.removePublishedFile(path: path, completion: completion)
    }
    
    func fetchDataOfPublishedFolder(publicUrl: String?, completion: @escaping () -> Void) {
        
        model.getDataOfPublishedFolder(publicUrl: publicUrl, completion: completion)
    }
}
