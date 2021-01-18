//
//  UserModel+CoreDataProperties.swift
//  travel
//
//  Created by Дмитрий on 18.01.2021.
//
//

import Foundation
import CoreData


extension UserModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserModel> {
        return NSFetchRequest<UserModel>(entityName: "UserModel")
    }

    @NSManaged public var accessToken: String?
    @NSManaged public var id: UUID?
    @NSManaged public var refreshToken: String?
    @NSManaged public var username: String?

}

extension UserModel : Identifiable {

}
