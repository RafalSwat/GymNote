//
//  Profile.swift
//  GymNote
//
//  Created by Rafał Swat on 11/01/2021.
//  Copyright © 2021 Rafał Swat. All rights reserved.
//

import Foundation
import CoreData

public class Profile: NSManagedObject {
    @NSManaged public var userID: String?
    @NSManaged public var image: Data?
    @NSManaged public var lastImageActualization: Date?
}

extension Profile {
    static func getImageIfPossible() -> NSFetchRequest<Profile> {
        let request: NSFetchRequest<Profile> = Profile.fetchRequest() as! NSFetchRequest<Profile>
        return request
    }
}
