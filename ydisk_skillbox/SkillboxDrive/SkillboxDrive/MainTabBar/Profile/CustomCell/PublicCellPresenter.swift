//
//  PublicCellPresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 17.11.2023.
//

import Foundation

protocol PublicCellPresenterProtocol: AnyObject {
    func getImageForLatestCell(
        urlStr: String,
        completion: @escaping (Data) -> Void
    )
    func parseDate(_ str: String) -> Date
    func getOnlyDateRu(date: Date) -> String
    func getOnlyTime(date: Date) -> String
}

final class PublicCellPresenter: PublicCellPresenterProtocol {
    private var model: PublicCellModel = PublicCellModel()
    
    func getImageForLatestCell(urlStr: String, completion: @escaping (Data) -> Void) {
        NetworkService.shared.getImageForCell(urlStr: urlStr, completion: completion)
    }
    
    func parseDate(_ str: String) -> Date {
        model.parseDate(str)
    }
    
    func getOnlyDateRu(date: Date) -> String {
        model.getOnlyDateRu(date: date)
    }
    
    func getOnlyTime(date: Date) -> String {
        model.getOnlyTime(date: date)
    }
}
