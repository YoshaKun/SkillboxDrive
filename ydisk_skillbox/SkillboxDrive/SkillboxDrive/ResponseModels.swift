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

// MARK: - PublishedFiles
struct PublishedFiles: Codable {
    let items: [PublishedItems]?
}

// MARK: - PublishedItems
struct PublishedItems: Codable {
    let name: String?
    let public_url: String?
    let created: String?
    let size: Int?
    let path: String?
    let type: String?
    let preview: String?
}

// MARK: - PublishedFolder
struct PublishedFolder: Codable {
    let publicKey: String
    let publicURL: String
    let embedded: PublishedFiles
    let name: String
    let created: Date
    let path: String
    let type: String
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
}

// MARK: - Images
struct Images: Codable {
    let url: String?
    let name: String?
}
