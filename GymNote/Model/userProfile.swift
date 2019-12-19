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
    var userImage: Image
    var userHeight: Double
    var dateOfBirth: Date
    
    
    // default user for preview and ect.
    static let `default` = Self(
        uID: "0",
        email: "anonim@domain.com",
        name: "anonim",
        surname: "",
        gender: .non,
        profileImage: Image("staticImage"),
        height: 170.0,
        dateOfBirth: Date()
    )
    
    init(uID: String,
         email: String,
         name: String,
         surname: String,
         gender: Gender,
         profileImage: Image,
         height: Double,
         dateOfBirth: Date) {
        
        self.userID = uID
        self.userEmail = email
        self.userName = name
        self.userSurname = surname
        self.userGender = gender
        self.userImage = profileImage
        self.userHeight = height
        self.dateOfBirth = Date()
    }

    enum Gender: String, CaseIterable {
        case male = "male", female = "female", non = "non"
    }
}
