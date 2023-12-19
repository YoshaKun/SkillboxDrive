//
//  AllFilesPresenterInput.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 19.12.2023.
//

protocol AllFilesPresenterInput: AnyObject {
    func getModelData() -> LatestFiles
    func updateDataTableView ()
    func isPaginating() -> Bool
    func additionalGetingAllFiles ()
    func changePaginatingStateOnFalse()
}
