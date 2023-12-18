//
//  LatestPresenterOutput.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 18.12.2023.
//

protocol LatestPresenterOutput: AnyObject {
    func didSuccessUpdateTableView()
    func noInternetUpdateTableView()
    func didSuccessGetFileFromPath(
        title: String?,
        created: String?,
        type: String?,
        file: String?,
        path: String?
    )
    func didFailureGetFileFromPath()
    func didSuccessAdditionalGettingFiles()
    func didFailureAdditionalGettingFiles()
}
