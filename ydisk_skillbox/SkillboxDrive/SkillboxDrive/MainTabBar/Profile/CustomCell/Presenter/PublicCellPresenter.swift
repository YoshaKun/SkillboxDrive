//
//  PublicCellPresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 17.11.2023.
//

import Foundation

final class PublicCellPresenter {
    
    // MARK: - Private properties
    
    private let networkService: NetworkServiceLatestCellProtocol = NetworkService.shared
}

extension PublicCellPresenter: PublicCellPresenterInput {
    
    func getImageForLatestCell(urlStr: String, completion: @escaping (Data) -> Void) {
        networkService.getImageForCell(urlStr: urlStr, completion: completion)
    }
}
