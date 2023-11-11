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
