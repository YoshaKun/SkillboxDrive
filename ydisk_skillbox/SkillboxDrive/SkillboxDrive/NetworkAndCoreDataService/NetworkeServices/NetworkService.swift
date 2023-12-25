//
//  NetworkService.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 12.12.2023.
//

import Foundation

final class NetworkService {

    // MARK: - SingleTone

    static let shared = NetworkService(); private init() {}
    // Pagination FLAG
    var isPaginatingPublic = false
    var isPaginatingPublicOpen = false
    var isPaginatingLatest = false
    var isPaginatingAllFiles = false
    var isPaginatingAllOpenFolder = false
    // Public Model data
    var modelDataPublic = LatestFilesModel(items: [])
    var modelDataPublicOpen = LatestFilesModel(items: [])
    var modelDataLatest = LatestFilesModel(items: [])
    var modelDataAllFiles = LatestFilesModel(items: [])
    var modelDataAllOpenFolder = LatestFilesModel(items: [])
}
