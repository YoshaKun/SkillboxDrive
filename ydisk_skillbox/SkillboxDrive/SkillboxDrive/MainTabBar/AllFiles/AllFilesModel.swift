//
//  jkgsdjkhf.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 02.12.2023.
//

import Foundation

final class AllFilesModel {

    func determinationOfFileType(path: String) -> String {
        guard let index = path.firstIndex(of: ".") else {
            let str = "dir"
            return str}
        var fileType = path[index ..< path.endIndex]
        fileType.removeFirst()
        let newString = String(fileType)
        return newString
    }
 }
