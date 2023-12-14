//
//  ProfilePresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 25.10.2023.
//

import Foundation
import UIKit

protocol ProfilePresenterProtocol {
    
    func didTapOnYesAlert()
    func updateToken (newToken: String?)
    func getConvertedBytesTotal (value: Int) -> Double
    func getConvertedBytesUsed (value: Int) -> Double
    func getConvertedBytesTotalToString (value: Int) -> String
    func getConvertedBytesUsedToString (value: Int) -> String
    func getConvertedBytesRemainsToString (total: Int, used: Int) -> String
    func updatePieChartData(
        completion: @escaping (
            _ totalSpace: Int?,
            _ usedSpace: Int?
        ) -> Void,
        errorHandler: @escaping () -> Void
    )
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    private var model: ProfileModel = ProfileModel()
    
    func didTapOnYesAlert() {
        model.didTapOnYesAlert()
    }
    
    func updateToken(newToken: String?) {
        model.updateToken(newToken: newToken)
    }
    
    func getConvertedBytesTotal(value: Int) -> Double {
        let converter = Units(bytes: Int64(value))
        return converter.gigabytes
    }
    
    func getConvertedBytesUsed(value: Int) -> Double {
        let converter = Units(bytes: Int64(value))
        return converter.gigabytes
    }
    
    func getConvertedBytesTotalToString(value: Int) -> String {
        let converter = Units(bytes: Int64(value))
        return converter.getReadableUnit()
    }
    
    func getConvertedBytesUsedToString(value: Int) -> String {
        let converter = Units(bytes: Int64(value))
        return converter.getReadableUnit()
    }
    
    func getConvertedBytesRemainsToString(total: Int, used: Int) -> String {
        let remain = total - used
        let converter = Units(bytes: Int64(remain))
        return converter.getReadableUnit()
    }
    
    func updatePieChartData(
        completion: @escaping (
            _ totalSpace: Int?,
            _ usedSpace: Int?
        ) -> Void,
        errorHandler: @escaping () -> Void
    ) {
        NetworkService.shared.updatePieChartData(completion: completion, errorHandler: errorHandler)
    }
}
