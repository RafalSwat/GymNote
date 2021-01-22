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
    var userImage: UIImage
    var userHeight: Int
    var userDateOfBirth: Date
    var lastImageActualization: Date?
    
    init() {
        
        self.userID = "0"
        self.userEmail = "name@domain.com"
        self.userName = "Anonim"
        self.userSurname = ""
        self.userGender = "non"
        self.userImage = UIImage(named: "staticImage")!
        self.userHeight = 170
        self.userDateOfBirth = Date()
    }
    
    init(uID: String,
         email: String,
         name: String,
         surname: String,
         gender: String,
         profileImage: UIImage,
         height: Int,
         userDateOfBirth: Date,
         lastImageActualization: Date?) {
        
        self.userID = uID
        self.userEmail = email
        self.userName = name
        self.userSurname = surname
        self.userGender = gender
        self.userImage = profileImage
        self.userHeight = height
        self.userDateOfBirth = userDateOfBirth
        self.lastImageActualization = lastImageActualization
    }


}
