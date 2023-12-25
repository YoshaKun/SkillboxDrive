//
//  RenameFilePresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 25.11.2023.
//

import Foundation

final class RenameFilePresenter {

    // MARK: - Public properties

    weak var output: RenameFilePresenterOutput?

    // MARK: - Private

    private let networkService: NetworkServiceRenameFilePresenter

    // MARK: - Initialization

    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension RenameFilePresenter: RenameFilePresenterInput {

    func renameFile(from: String?, path: String?) {
        networkService.renameFile(
            from: from,
            path: path
        ) { [weak self] in
            self?.output?.didSuccessRenameFile()
        }
    }
}
