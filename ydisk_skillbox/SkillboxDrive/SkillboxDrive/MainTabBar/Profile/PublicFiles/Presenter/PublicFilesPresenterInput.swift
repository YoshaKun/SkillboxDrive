//
//  PublicFilesPresenterInput.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 20.12.2023.
//

protocol PublicFilesPresenterInput: AnyObject {
    func updateDataTableView()
    func getModelData() -> LatestFilesModel
    func removePublishedData(path: String?)
    func isPaginating() -> Bool
    func additionalGetingPublishedFiles()
    func changePaginatingStateOnFalse()
}
