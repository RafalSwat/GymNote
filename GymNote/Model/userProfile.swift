//
//  UserProfile.swift
//  GymNote
//
//  Created by Rafał Swat on 04/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import Foundation
import SwiftUI


struct UserProfile {
    
    var userID: String
    var userEmail: String
    var userName: String
    var userSurname: String
    var userGender: Gender
    var userImage: UIImage
    var userHeight: Double
    
    
    // default user for preview and ect.
    static let `default` = Self(
        uID: "0",
        email: "anonim@domain.com",
        name: "anonim",
        surname: "",
        gender: .non,
        profileImage: UIImage(named: "staticImage")!,
        height: 170.0)
    
    init(uID: String,
         email: String,
         name: String,
         surname: String,
         gender: Gender,
         profileImage: UIImage,
         height: Double) {
        
        self.userID = uID
        self.userEmail = email
        self.userName = name
        self.userSurname = surname
        self.userGender = gender
        self.userImage = profileImage
        self.userHeight = height
    }

    enum Gender {
        case male, female, non
    }
}
