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
    var userGender: String
    var userImage: Image
    var userHeight: Int
    var userDateOfBirth: Date
    
    init() {
        
        self.userID = "0"
        self.userEmail = "name@domain.com"
        self.userName = "Anonim"
        self.userSurname = ""
        self.userGender = "non"
        self.userImage = Image("staticImage")
        self.userHeight = 170
        self.userDateOfBirth = Date()
    }
    
    init(uID: String,
         email: String,
         name: String,
         surname: String,
         gender: String,
         profileImage: Image,
         height: Int,
         userDateOfBirth: Date) {
        
        self.userID = uID
        self.userEmail = email
        self.userName = name
        self.userSurname = surname
        self.userGender = gender
        self.userImage = profileImage
        self.userHeight = height
        self.userDateOfBirth = Date()
    }


}
