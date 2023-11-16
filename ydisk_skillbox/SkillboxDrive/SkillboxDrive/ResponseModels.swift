//
//  DiskResponse.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 06.11.2023.
//

import Foundation

struct DiskSpaceResponse: Codable {
    let total_space: Int?
    let used_space: Int?
}

struct PublishedFiles: Codable {
    let items: [PublishedItems]?
}

struct PublishedItems: Codable {
    let name: String?
    let created: String?
    let size: Int?
    let type: String?
    let preview: String?
}

struct LatestFiles: Codable {
    let items: [LatestItems]?
}

struct LatestItems: Codable {
    let name: String?
    let created: String?
    let size: Int?
    let type: String?
    let preview: String?
}
