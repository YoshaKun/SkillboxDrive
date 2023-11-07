//
//  DiskResponse.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 06.11.2023.
//

import Foundation

struct DiskResponse: Codable {
    
    let items: [DiskFile]?
}

struct DiskFile: Codable {
    
    let name: String?
    let preview: String?
    let size: Int64?
}
