//
//  LatestCellPresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 17.11.2023.
//

import Foundation

final class LatestCellPresenter {

    // MARK: - Private properties

    private let networkService: NetworkServiceLatestCellProtocol = NetworkService.shared
}

extension LatestCellPresenter: LatestCellPresenterInput {

    func getImageForLatestCell(
        urlStr: String,
        completion: @escaping (Data) -> Void
    ) {
        networkService.getImageForCell(
            urlStr: urlStr,
            completion: completion
        )
    }
}
