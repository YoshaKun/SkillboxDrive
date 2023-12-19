//
//  ProfilePresenterInput.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 19.12.2023.
//

protocol ProfilePresenterInput {
    
    func didTapOnYesAlert()
    func updateToken (newToken: String?)
    
    func getConvertedBytesTotal (value: Int) -> Double
    func getConvertedBytesUsed (value: Int) -> Double
    func getConvertedBytesTotalToString (value: Int) -> String
    func getConvertedBytesUsedToString (value: Int) -> String
    func getConvertedBytesRemainsToString (total: Int, used: Int) -> String
    
    func updatePieChartData()
}
