//
//  ViewingScreenPresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 20.11.2023.
//

import Foundation

final class ViewingScreenPresenter {

    // MARK: - Public properties

    weak var output: ViewingScreenPresenterOutput?

    // MARK: - Private

    private let networkService: NetworkServiceViewingProtocol

    // MARK: - Initialization

    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

// MARK: - extension ViewingScreenPresenterInput

extension ViewingScreenPresenter: ViewingScreenPresenterInput {
    func getImage(urlStr: String) {
        networkService.getImageForView(urlStr: urlStr) { [weak self] data in
            self?.output?.didSuccessGettingImage(data: data)
        }
    }
    func delete(path: String?) {
        networkService.deleteFile(path: path) { [weak self] in
            self?.output?.didSuccessDeleting()
        }
    }
    func getLinkFile(path: String?) {
        networkService.getLinkFile(path: path) { [weak self] in
            self?.output?.didSuccessGettingLink()
        }
    }
}
