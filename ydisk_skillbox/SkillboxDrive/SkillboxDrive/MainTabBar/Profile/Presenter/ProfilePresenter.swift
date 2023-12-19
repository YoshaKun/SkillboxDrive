//
//  ProfilePresenter.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 25.10.2023.
//

import Foundation

final class ProfilePresenter {
    
    // MARK: - Public properties
    
    weak var output: ProfilePresenterOutput?
    
    // MARK: - Private
    
    private let networkService: NetworkServiceProfileProtocol
    
    // MARK: - Initialization
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension ProfilePresenter: ProfilePresenterInput {
    
    func didTapOnYesAlert() {
        UserDefaults.standard.removeObject(forKey: Keys.apiToken)
        print("Did token deleted? = \(Keys.apiToken.isEmpty)")
        Core.shared.setNewUser()
        print("Did user deleted? = \(Core.shared.isNewUser())")
        DispatchQueue.main.async {
            let cookiesCleaner = WebCacheCleaner()
            cookiesCleaner.clean()
        }
    }
    
    func updateToken(newToken: String?) {
        guard let newToken = newToken else { return }
        UserDefaults.standard.set(newToken, forKey: Keys.apiToken)
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

    func updatePieChartData() {
        networkService.updatePieChartData { [weak self] totalSpace, usedSpace in
            self?.output?.didSuccessUpdatePieChart(
                total: totalSpace,
                used: usedSpace
            )
        } errorHandler: { [weak self] in
            self?.output?.didFailureUpdatePieChart()
        }
    }
}
