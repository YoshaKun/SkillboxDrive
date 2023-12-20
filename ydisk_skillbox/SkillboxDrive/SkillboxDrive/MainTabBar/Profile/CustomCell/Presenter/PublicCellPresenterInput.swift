//
//  PublicCellPresenterInput.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 20.12.2023.
//

import Foundation

protocol PublicCellPresenterInput: AnyObject {
    func getImageForLatestCell(
        urlStr: String,
        completion: @escaping (Data) -> Void
    )
}
