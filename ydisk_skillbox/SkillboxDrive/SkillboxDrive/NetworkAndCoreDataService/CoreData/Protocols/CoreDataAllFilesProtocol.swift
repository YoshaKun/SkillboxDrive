//
//  CoreDataAllFilesProtocol.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 22.12.2023.
//

import Foundation
import CoreData

protocol CoreDataAllFilesProtocol {
    func saveAllFilesOnCoreData(openList: LatestFilesModel)
    func deleteAllFilesFromCoreData()
    func fetchAllFilesCoreData() -> LatestFilesModel
}

extension CoreDataManager: CoreDataAllFilesProtocol {

    func saveAllFilesOnCoreData(openList: LatestFilesModel) {
        guard let fetchedArray = openList.items else { return }
        var savedArry = [AllFiles]()
        for items in fetchedArray {
            let model = AllFiles(context: viewContext)
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

    func deleteAllFilesFromCoreData() {
        let publicFetchRequest = AllFiles.fetchRequest()
        guard let objects = try? viewContext.fetch(publicFetchRequest) else { return }
        for object in objects {
            viewContext.delete(object)
        }
        saveContext()
    }

    func fetchAllFilesCoreData() -> LatestFilesModel {
        let publicFetchRequest = AllFiles.fetchRequest()
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
