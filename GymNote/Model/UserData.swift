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
    @Published var userTrainings: [Training]
    @Published var userStatistics: [ExerciseStatistics]
    @Published var userCalendar: UsersCalendar

    init(profile: UserProfile) {
        self.userProfile = profile
        self.userTrainings = [Training]()
        self.userStatistics = [ExerciseStatistics]()
        self.userCalendar = UsersCalendar()
    }
}

