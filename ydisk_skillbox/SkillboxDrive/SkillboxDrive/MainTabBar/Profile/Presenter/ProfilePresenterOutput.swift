//
//  ProfilePresenterOutput.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 19.12.2023.
//

protocol ProfilePresenterOutput: AnyObject {
    func didSuccessUpdatePieChart(total: Int?, used: Int?)
    func didFailureUpdatePieChart()
}
