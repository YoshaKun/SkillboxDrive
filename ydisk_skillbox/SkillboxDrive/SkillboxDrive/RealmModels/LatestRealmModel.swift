//
//  HUHjkfh.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 28.11.2023.
//

import RealmSwift

class LatestRealmModel: Object {
    
    @objc dynamic var name: String?
    @objc dynamic var created: String?
    @objc dynamic var file: String?
    @objc dynamic var path: String?
    @objc dynamic var type: String?
    @objc dynamic var size: Int = 0
    @objc dynamic var preview: String?
    @objc dynamic var public_url: String?
}
