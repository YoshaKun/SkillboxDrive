//
//  DiskResponse.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 06.11.2023.
//

import Foundation

// MARK: - DiskSpaceResponse
struct DiskSpaceResponse: Codable {
    let totalSpace: Int?
    let usedSpace: Int?
}

// MARK: - PublishedFolder
struct PublishedFolder: Codable {
    let embedded: LatestFiles
}

// MARK: - LatestFiles
struct LatestFiles: Codable {
    var items: [LatestItems]?
}

// MARK: - LatestItems
struct LatestItems: Codable {
    let name: String?
    let created: String?
    let sizes: [Images]?
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

// MARK: - MyCodingKey - need for translate JSON format Snake_Case to camelCase only for JSON data begins from "_"
struct MyCodingKey: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    var intValue: Int?
    init?(intValue: Int) {
        return nil
    }
}

// MARK: - Extension for spacial decoding JSON data, including in begining sign "_"
extension JSONDecoder {
    func dashDecoding() -> JSONDecoder {
        self.keyDecodingStrategy = .custom({ keys in
            let lastKey = keys.last!
            let lastKeySegment = lastKey.stringValue.split(separator: "_").last
            let updatedKey = lastKeySegment.map { String($0) } ?? ""
            return MyCodingKey(stringValue: updatedKey) ?? lastKey
        })
        return self
    }
}
