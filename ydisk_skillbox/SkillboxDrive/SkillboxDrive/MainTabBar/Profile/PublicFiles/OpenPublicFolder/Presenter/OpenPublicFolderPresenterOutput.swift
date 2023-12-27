//
//  OpenPublicFolderPresenterOutput.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 20.12.2023.
//

protocol OpenPublicFolderPresenterOutput: AnyObject {
    func didSuccessUpdateDataTableView()
    func didFailureUpdateDataTableView()
    func noFilesUpdateDataTableView()
    func noInternetUpdateDataTableView()

    func didSuccessRemovePublishedData()
    func didFailureRemovePublishedData()

    func didSuccessAdditionalGettingData()
    func didFailureAdditionalGettingData()
}
