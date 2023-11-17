//
//  PublicCellPresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 17.11.2023.
//

import Foundation

protocol PublicCellPresenterProtocol: AnyObject {

    func getImageForLatestCell(urlStr: String, completion: @escaping (Data) -> Void)
}

final class PublicCellPresenter: PublicCellPresenterProtocol {
    
    private var model: PublicCellModel = PublicCellModel()
    
    func getImageForLatestCell(urlStr: String, completion: @escaping (Data) -> Void) {
        
        model.getImageForCell(urlStr: urlStr, completion: completion)
    }
}
