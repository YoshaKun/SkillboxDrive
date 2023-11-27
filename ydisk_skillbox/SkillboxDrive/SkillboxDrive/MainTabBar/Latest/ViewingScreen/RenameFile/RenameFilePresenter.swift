//
//  RenameFilePresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 25.11.2023.
//

import Foundation

protocol RenameFilePresenterProtocol {
    
    func renameFile(from: String?, path: String?, completion: @escaping () -> Void)
}

final class RenameFilePresenter: RenameFilePresenterProtocol {
    
    private var model: RenameFileModel = RenameFileModel()
    
    func renameFile(from: String?, path: String?, completion: @escaping () -> Void) {
        
        model.renameFile(from: from, path: path, completion: completion)
    }
}
