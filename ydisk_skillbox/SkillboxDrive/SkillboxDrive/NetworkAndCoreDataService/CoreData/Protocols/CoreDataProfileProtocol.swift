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
    func deleteFromCoreData(_ profile: ProfileEntity)
    func fetchProfileCoreData() -> [ProfileEntity]
}

extension CoreDataManager: CoreDataProfileProtocol {
    
    func saveOnCoreData(total: Int64, used: Int64) {
        let profileMemory = ProfileEntity(context: viewContext)
        profileMemory.totalSpace = total
        profileMemory.usedSpace = used
        saveContext()
    }
    
    func deleteFromCoreData(_ profile: ProfileEntity) {
        viewContext.delete(profile)
        saveContext()
    }
    
    func fetchProfileCoreData() -> [ProfileEntity] {
        let profileFetchRequest = ProfileEntity.fetchRequest()
//        let sortDescriptor = NSSortDescriptor(key: "", ascending: true)
//        profileFetchRequest.sortDescriptors = [sortDescriptor]
        let result = try? viewContext.fetch(profileFetchRequest)
        return result ?? []
    }
}
