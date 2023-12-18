//
//  MVPExamplePresenterOutput.swift
//  SkillboxDrive
//
//  Created by Евгений Капанов on 14.12.2023.
//

protocol MVPExamplePresenterOutput: AnyObject {
    func didSuccessUpdateDataTableView()
    func didFailureUpdateDataTableView()
    
    func startLoader()
    func hideLoader()
}
