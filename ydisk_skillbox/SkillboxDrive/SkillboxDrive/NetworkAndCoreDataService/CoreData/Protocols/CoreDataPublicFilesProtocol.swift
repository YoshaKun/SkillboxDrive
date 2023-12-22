//
//  CoreDataPublicFilesProtocol.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 22.12.2023.
//

import Foundation
import CoreData

protocol CoreDataPublicFilesProtocol {
    func saveOnCoreData(publicList: LatestFilesModel)
    func deletePublicFilesFromCoreData()
    func fetchProfileCoreData() -> LatestFilesModel
}

extension CoreDataManager: CoreDataPublicFilesProtocol {

    func saveOnCoreData(publicList: LatestFilesModel) {
        guard let fetchedArray = publicList.items else { return }
        var savedArry = [PublicFiles]()
        for items in fetchedArray {
            let model = PublicFiles(context: viewContext)
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

    func deletePublicFilesFromCoreData() {
        let publicFetchRequest = PublicFiles.fetchRequest()
        guard let objects = try? viewContext.fetch(publicFetchRequest) else { return }

        for object in objects {
            viewContext.delete(object)
        }
        saveContext()
    }

    func fetchProfileCoreData() -> LatestFilesModel {
        let publicFetchRequest = PublicFiles.fetchRequest()
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
