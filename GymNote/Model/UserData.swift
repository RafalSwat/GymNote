//
//  UserData.swift
//  GymNote
//
//  Created by Rafał Swat on 23/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import SwiftUI
import Combine


final class UserData: ObservableObject {
    @Published var userProfile: UserProfile
    @Published var userTrainings: UserTrainings?
    
    init(profile: UserProfile, uID: String) {
        self.userProfile = profile
        self.userTrainings = UserTrainings(id: uID, trainings: [Training]())
    }
}

