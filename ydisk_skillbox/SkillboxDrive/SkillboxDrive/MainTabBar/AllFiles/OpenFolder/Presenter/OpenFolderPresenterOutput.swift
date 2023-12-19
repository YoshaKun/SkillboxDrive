//
//  OpenFolderPresenterOutput.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 19.12.2023.
//

import Foundation

protocol OpenFolderPresenterOutput: AnyObject {
    func didSuccessUpdateTableView()
    func didFailureUpdateTableView()
    func noInternetUpdateTableView()
    func didSuccessAdditionalGetting()
    func didFailureAdditionalGetting()
}
