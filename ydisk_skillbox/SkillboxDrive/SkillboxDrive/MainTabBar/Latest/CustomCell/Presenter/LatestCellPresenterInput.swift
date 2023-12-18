//
//  LatestCellPresenterInput.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 18.12.2023.
//

import Foundation

protocol LatestCellPresenterInput: AnyObject {
    func getImageForLatestCell(
        urlStr: String,
        completion: @escaping (Data) -> Void
    )
}
