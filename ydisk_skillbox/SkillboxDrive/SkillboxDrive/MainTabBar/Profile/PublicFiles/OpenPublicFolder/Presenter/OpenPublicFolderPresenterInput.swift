//
//  OpenPublicFolderPresenterInput.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 20.12.2023.
//

protocol OpenPublicFolderPresenterInput: AnyObject {
    func getModelData() -> LatestFilesModel
    func removePublishedData(path: String?)
    func updateDataTableView(publicUrl: String?)
    func isPaginating() -> Bool
    func additionalGettingDataOfPublishedFolder (publicUrl: String?)
    func changePaginatingStateOnFalse()
}
