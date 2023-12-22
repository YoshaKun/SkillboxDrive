//
//  AllFilesPresenterOutput.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 19.12.2023.
//

protocol AllFilesPresenterOutput: AnyObject {
    func didSuccessUpdateTableView()
    func didFailureUpdateTableView()
    func noInternetUpdateTableView()

    func didSuccessAdditionalGetingAllFiles()
    func didFailureAdditionalGetingAllFiles()
}
