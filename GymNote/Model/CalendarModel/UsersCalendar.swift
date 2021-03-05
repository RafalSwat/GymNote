//
//  UsersCalendar.swift
//  GymNote
//
//  Created by Rafał Swat on 03/03/2021.
//  Copyright © 2021 Rafał Swat. All rights reserved.
//

import Foundation
import SwiftUI

class UsersCalendar: ObservableObject {
    
    @Published var trainingSessions: [TrainingSession]
    @Published var calendarNotes: [CalendarNote]
    
    init(sessions: [TrainingSession],
         notes: [CalendarNote]) {
        
        self.trainingSessions = sessions
        self.calendarNotes = notes
    }
    init() {
        self.trainingSessions = [TrainingSession]()
        self.calendarNotes = [CalendarNote]()
    }
}
