//
//  ViewingScreenPresenterInput.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 25.12.2023.
//

import Foundation

protocol ViewingScreenPresenterInput {

    func getImage(urlStr: String)
    func delete(path: String?)
    func getLinkFile(path: String?)
}
