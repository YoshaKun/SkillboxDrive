//
//  ProfileEntity+CoreDataProperties.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 22.12.2023.
//
//

import Foundation
import CoreData

extension ProfileEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileEntity> {
        return NSFetchRequest<ProfileEntity>(entityName: "ProfileEntity")
    }

    @NSManaged public var totalSpace: Int64
    @NSManaged public var usedSpace: Int64

}

extension ProfileEntity: Identifiable {

}
