//
//  DiskResponse.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 06.11.2023.
//

import Foundation

// MARK: - DiskSpaceResponse
struct DiskSpaceResponse: Codable {
    let total_space: Int?
    let used_space: Int?
}

// MARK: - LatestFiles
struct LatestFiles: Codable {
    let items: [LatestItems]?
}

// MARK: - LatestItems
struct LatestItems: Codable {
    let name: String?
    let created: String?
    let sizes: [Images]
    let file: String?
    let path: String?
    let type: String?
    let size: Int?
    let preview: String?
    let public_url: String?
}

// MARK: - Images
struct Images: Codable {
    let url: String?
    let name: String?
}

// MARK: - ShareLink
struct ShareLink: Codable {
    let href: String?
}
