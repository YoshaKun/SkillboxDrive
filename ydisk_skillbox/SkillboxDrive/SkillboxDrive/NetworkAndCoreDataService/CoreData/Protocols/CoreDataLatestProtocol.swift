//
//  CoreDataOpenPublicProtocol.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 22.12.2023.
//

import Foundation
import CoreData

protocol CoreDataLatestProtocol {
    func saveLatestFilesOnCoreData(openList: LatestFilesModel)
    func deleteLatestFilesFromCoreData()
    func fetchLatestFilesCoreData() -> LatestFilesModel
}

extension CoreDataManager: CoreDataLatestProtocol {

    func saveLatestFilesOnCoreData(openList: LatestFilesModel) {
        guard let fetchedArray = openList.items else { return }
        var savedArry = [LatestFiles]()
        for items in fetchedArray {
            let model = LatestFiles(context: viewContext)
            model.name = items.name
            model.created = items.created
            model.file = items.file
            model.path = items.path
            model.type = items.type
            model.size = Int64(items.size ?? 0)
            model.preview = items.preview
            model.publicUrl = items.publicUrl
            savedArry.append(model)
        }
        saveContext()
    }
    
    func deleteLatestFilesFromCoreData() {
        let publicFetchRequest = LatestFiles.fetchRequest()
        guard let objects = try? viewContext.fetch(publicFetchRequest) else { return }
        for object in objects {
            viewContext.delete(object)
        }
        saveContext()
    }

    func fetchLatestFilesCoreData() -> LatestFilesModel {
        let publicFetchRequest = LatestFiles.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "type", ascending: true)
        publicFetchRequest.sortDescriptors = [sortDescriptor]
        guard let result = try? viewContext.fetch(publicFetchRequest) else {
            return LatestFilesModel()
        }
        var publicFiles = LatestFilesModel(items: [])
        for data in result {
            let latestItem = LatestItems(
                name: data.name,
                created: data.created,
                sizes: [],
                file: data.file,
                path: data.path,
                type: data.type,
                size: Int(data.size),
                preview: data.preview,
                publicUrl: data.publicUrl
            )
            publicFiles.items?.append(latestItem)
        }
        return publicFiles
    }
}
