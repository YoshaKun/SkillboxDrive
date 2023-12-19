//
//  OpenFolderPresenterInput.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 19.12.2023.
//

protocol OpenFolderPresenterInput {
    func getModelData() -> LatestFiles
    func updateDataTableView(path: String?)
    func isPaginatingOpenFolder() -> Bool
    func additionalGettingFiles(path: String?)
    func changePaginatingStateOnFalse()
}
