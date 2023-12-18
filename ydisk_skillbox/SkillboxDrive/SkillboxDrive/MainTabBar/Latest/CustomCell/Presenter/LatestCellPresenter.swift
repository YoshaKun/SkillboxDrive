//
//  LatestCellPresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 17.11.2023.
//

import Foundation

protocol LatestCellPresenterProtocol {
    
    func getImageForLatestCell(
        urlStr: String,
        completion: @escaping (Data) -> Void
    )
}

final class LatestCellPresenter: LatestCellPresenterProtocol {
    
    func getImageForLatestCell(
        urlStr: String,
        completion: @escaping (Data) -> Void
    ) {
        NetworkService.shared.getImageForCell(
            urlStr: urlStr,
            completion: completion
        )
    }
}
