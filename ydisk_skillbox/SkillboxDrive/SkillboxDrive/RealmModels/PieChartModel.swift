//
//  ProfileRealmModel.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 27.11.2023.
//

import Foundation
import RealmSwift

class PieChartModel: Object {
    
    @objc dynamic var busy: Int = 0
    @objc dynamic var free: Int = 0
}
