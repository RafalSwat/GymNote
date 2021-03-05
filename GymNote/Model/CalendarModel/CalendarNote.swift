//
//  CalendarNotes.swift
//  GymNote
//
//  Created by Rafał Swat on 03/03/2021.
//  Copyright © 2021 Rafał Swat. All rights reserved.
//

import Foundation
import SwiftUI

class CalendarNote: ObservableObject, Hashable {
    
    var notesID: String
    var notesDate: Date
    var note: String
    @Published var isCompleted: Bool
    
    init(notesID: String,
         notesDate: Date,
         note: String,
         isCompleted: Bool) {
        
        self.notesID = notesID
        self.notesDate = notesDate
        self.note = note
        self.isCompleted = isCompleted
    }
    init(notesDate: Date,
         notes: String) {
        
        self.notesID = UUID().uuidString
        self.notesDate = notesDate
        self.note = notes
        self.isCompleted = false
    }
    
    init(notes: String) {
        
        self.notesID = UUID().uuidString
        self.notesDate = Date()
        self.note = notes
        self.isCompleted = false
    }
    
    //MARK: String is a built-in type, which means it is hashable by default
    func hash(into hasher: inout Hasher) {
        return hasher.combine(notesID)
    }
    
    //MARK: Hashable inherits from Equatable so our struct must implemented requirements for both
    //We must implemented func that compare two var, to chceck if there are equal or not (Equatable protocol)
    public static func == (lhs: CalendarNote, rhs: CalendarNote) -> Bool {
        return lhs.notesID == rhs.notesID
    }
}
