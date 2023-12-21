//
//  LoginScreenPresenterInput.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 21.12.2023.
//

protocol LoginScreenPresenterInput: AnyObject {
    func getToken() -> String
    func updateToken(newToken: String?)
}
