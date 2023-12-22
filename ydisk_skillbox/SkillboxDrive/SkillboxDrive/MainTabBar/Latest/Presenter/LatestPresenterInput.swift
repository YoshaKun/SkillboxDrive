//
//  LatestPresenterInput.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 18.12.2023.
//

protocol LatestPresenterInput {
    
    func updateDataTableView()
    func getModelData() -> LatestFilesModel
    func fetchLatestModelFromCoreData() -> LatestFilesModel
    func getFileFromPath(
        title: String?,
        created: String?,
        type: String?,
        file: String?,
        path: String?
    )
    func additionalGetingLatestFiles ()
    func isPaginating() -> Bool
    func changePaginatingStateOnFalse()
}
