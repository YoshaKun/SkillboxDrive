//
//  LatestFiles+CoreDataProperties.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 21.12.2023.
//
//

import Foundation
import CoreData

extension LatestFiles {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LatestFiles> {
        return NSFetchRequest<LatestFiles>(entityName: "LatestFiles")
    }

    @NSManaged public var name: String?
    @NSManaged public var created: String?
    @NSManaged public var file: String?
    @NSManaged public var path: String?
    @NSManaged public var type: String?
    @NSManaged public var size: Int64
    @NSManaged public var preview: String?
    @NSManaged public var publicUrl: String?

}

extension LatestFiles: Identifiable {

}
