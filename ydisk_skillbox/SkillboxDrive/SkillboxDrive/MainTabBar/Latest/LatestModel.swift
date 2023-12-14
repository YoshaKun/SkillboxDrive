//
//  LatestModel.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 16.11.2023.
//

import Foundation

final class LatestModel {
    
    // MARK: - DeterminationOfFileType
    func determinationOfFileType(path: String) -> String {
        let index = path.firstIndex(of: ".") ?? path.endIndex
        var fileType = path[index ..< path.endIndex]
        fileType.removeFirst()
        let newString = String(fileType)
        return newString
    }
}
