//
//  NetworkService.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 12.12.2023.
//

import Foundation

class NetworkService {
    
    // MARK: - SingleTone
    
    static let shared = NetworkService(); private init() {}
    // Pagination FLAG
    var isPaginatingPublic = false
    var isPaginatingPublicOpen = false
    var isPaginatingLatest = false
    var isPaginatingAllFiles = false
    var isPaginatingAllOpenFolder = false
    // Public Model data
    var modelDataPublic = LatestFiles(items: [])
    var modelDataPublicOpen = LatestFiles(items: [])
    var modelDataLatest = LatestFiles(items: [])
    var modelDataAllFiles = LatestFiles(items: [])
    var modelDataAllOpenFolder = LatestFiles(items: [])
}
