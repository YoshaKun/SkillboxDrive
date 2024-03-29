//
//  CoreDataProfileProtocol.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 22.12.2023.
//

import Foundation
import CoreData

protocol CoreDataProfileProtocol {
    func saveOnCoreData(total: Int64, used: Int64)
    func deleteProfileDataFromCoreData()
    func fetchProfileCoreData() -> [ProfileEntity]
}

extension CoreDataManager: CoreDataProfileProtocol {

    func saveOnCoreData(total: Int64, used: Int64) {
        let profileMemory = ProfileEntity(context: viewContext)
        profileMemory.totalSpace = total
        profileMemory.usedSpace = used
        saveContext()
    }

    func deleteProfileDataFromCoreData() {
        let fetchRequest = ProfileEntity.fetchRequest()
        guard let objects = try? viewContext.fetch(fetchRequest) else { return }

        for object in objects {
            viewContext.delete(object)
        }
        saveContext()
    }

    func fetchProfileCoreData() -> [ProfileEntity] {
        let profileFetchRequest = ProfileEntity.fetchRequest()
        let result = try? viewContext.fetch(profileFetchRequest)
        return result ?? []
    }
}
