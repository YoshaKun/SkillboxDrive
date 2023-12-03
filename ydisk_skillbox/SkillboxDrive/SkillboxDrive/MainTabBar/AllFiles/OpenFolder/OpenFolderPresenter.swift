//
//  OpenFolderPresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 02.12.2023.
//

import Foundation

protocol OpenFolderPresenterProtocol {
    
    func getModelData() -> LatestFiles
    
    func updateDataTableView(path: String?,
                             completion: @escaping () -> Void,
                             errorHandler: @escaping () -> Void,
                             noInternet: @escaping () -> Void)
    
    func fetchDataOfPublishedFolder(publicUrl: String?,
                                    completion: @escaping () -> Void,
                                    errorHandler: @escaping () -> Void,
                                    noInternet: @escaping () -> Void)
}

final class OpenFolderPresenter: OpenFolderPresenterProtocol {
    
    private var model: OpenFolderModel = OpenFolderModel()
    
    func getModelData() -> LatestFiles {
        
        let data = model.modelData
        if data.items!.isEmpty {
            print("сработал метод readPublicFilesRealm")
            return model.readPublicFilesRealm()
        }
        return data
    }
    
    func updateDataTableView(path: String?, completion: @escaping () -> Void, errorHandler: @escaping () -> Void, noInternet: @escaping () -> Void) {
        
        model.getAllFiles(path: path, completion: completion, errorHandler: errorHandler, noInternet: noInternet)
    }
    
    func fetchDataOfPublishedFolder(publicUrl: String?,
                                    completion: @escaping () -> Void,
                                    errorHandler: @escaping () -> Void,
                                    noInternet: @escaping () -> Void) {
        
        model.getDataOfPublishedFolder(publicUrl: publicUrl,
                                       completion: completion,
                                       errorHandler: errorHandler,
                                       noInternet: noInternet)
    }
}

