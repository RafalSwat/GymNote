//
//  User.swift
//  GymNote
//
//  Created by Rafał Swat on 04/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import Foundation
import SwiftUI

class User: ObservableObject {
    
    var userEmail: String
    
    var userName: String = ""
    var userSurname: String = ""
    var userGender: Gender = .non
    var userImage: UIImage = UIImage(named: "staticImage")!
    var userHeight: Double = 0
    
    
    
    
    enum Gender {
        case male, female, non
    }
    
}
