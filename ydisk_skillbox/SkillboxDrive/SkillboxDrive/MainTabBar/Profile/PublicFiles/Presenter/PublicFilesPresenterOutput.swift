//
//  PublicFilesPresenterOutput.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 20.12.2023.
//

protocol PublicFilesPresenterOutput: AnyObject {
    func didSuccessGettingPublishedFiles()
    func didFailureGettingPublishedFiles()
    func noInternetGettingPublishedFiles()
    
    func didSuccessRemovePublishedFile()
    func didFailureRemovePublishedFile()
    
    func didSuccessAdditionalPublishedFiles()
    func didFailureAdditionalPublishedFiles()
}
