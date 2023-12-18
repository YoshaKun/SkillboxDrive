//
//  NetworkServiceLatestCellProtocol.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 18.12.2023.
//

import Foundation

protocol NetworkServiceLatestCellProtocol: AnyObject {
    func getImageForLatestCell(
        urlStr: String,
        completion: @escaping (Data) -> Void
    )
}

extension NetworkService: NetworkServiceLatestCellProtocol {
    
    func getImageForLatestCell(
        urlStr: String,
        completion: @escaping (Data) -> Void
    ) {
        getImageForCell(
            urlStr: urlStr,
            completion: completion
        )
    }
}
