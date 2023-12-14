//
//  PublicCellModel.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 17.11.2023.
//

import Foundation

final class PublicCellModel {
    
    // MARK: - ParseDate
    func parseDate(_ str: String) -> Date {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormat.date(from: str) ?? Date()

        return date
    }
    
    func getOnlyDateRu(date: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.locale = Locale(identifier: "ru_RU")
        dateFormat.dateStyle = .short
        dateFormat.timeStyle = .none
        return dateFormat.string(from: date)
    }
    
    func getOnlyTime(date: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.locale = Locale(identifier: "ru_RU")
        dateFormat.dateStyle = .none
        dateFormat.timeStyle = .short
        return dateFormat.string(from: date)
    }
}
