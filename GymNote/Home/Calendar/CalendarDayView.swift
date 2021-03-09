//
//  CalendarDayView.swift
//  GymNote
//
//  Created by Rafał Swat on 03/03/2021.
//  Copyright © 2021 Rafał Swat. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct CalendarDayView: View {
    
    @EnvironmentObject var session: FireBaseSession
    @State var showButtons = false
    @State var note: String = ""
    @State var showWarninig = false
    @State var scrollViewHeight: CGFloat = 0
    @State var checkToDeleteArray = [Bool]()
    @State var disableAddButton = false
    @State var noteToDelete: CalendarNote?
    @State var showDetails = false
    @ObservedObject var listOfTrainingSessions: ObservableArray<TrainingSession>
    @ObservedObject var listOfNotes: ObservableArray<CalendarNote>
    @Binding var date: Date

    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Text("Day View")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                    Text(DateConverter.dateFormat.string(from: date))
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding(.bottom, 15)
            
            VStack {
                HStack {
                    TextField("add some note...", text: self.$note)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        self.saveNote()
                    }) {
                        Image(systemName: "plus.square")
                            .foregroundColor(.orange)
                            .font(.largeTitle)
                            .shadow(color: .black, radius: 2, x: -1, y: 1)
                    }.disabled(disableAddButton)
                }
                if showWarninig {
                    Text("you cannot add a blank note!")
                        .foregroundColor(.red)
                        .font(.footnote)
                }
            }
            .padding(.bottom, 20)
            
            Divider()
            
            ForEach(listOfTrainingSessions.array, id: \.trainingID) { training in
                
                if training.trainingDates.contains(where: {$0 == date }) {
                    SmallShowHideTrainingView(training: training)
                }
            }//.padding(.bottom, 15)
            Divider()
            ScrollView {
                ForEach(listOfNotes.array, id: \.notesID) { note in
                    if note.notesDate == date {
                        HStack {
                            
                            CompletedButton(isCompleted: note.isCompleted,
                                            action: {
                                                    self.updateIsCompletedOnNote(note: note)
                                                })
                            
                            Text(note.note)
                                .multilineTextAlignment(.leading)
                                .font(.headline)
                            Spacer()
                            ChaveronDeleteComplexButtons(deleteAction: {
                                self.deleteNote(note: note)
                            })
                        }
                    }
                }
            }
            .onAppear {
                self.setupScrollViewHightAndCheckArray()
            }
            .frame(height: scrollViewHeight)
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors:[Color.customLight, Color.customDark]), startPoint: .bottomLeading, endPoint: .topTrailing))
        .cornerRadius(15)
        
        
    }
    func saveNote() {
        if self.note == "" {
            self.showWarninig = true
        } else {
            self.disableAddButton = true
            let noteText = self.note
            let note = CalendarNote(notesDate: date,
                                    notes: noteText)
            if let id = self.session.userSession?.userProfile.userID {
                self.session.uploadCalendarNote(userID: id, calendarNote: note) { (error, errorDescription) in
                    if error {
                        print("Error during saving calendar note in Firebase: \(String(describing: errorDescription))")
                        self.disableAddButton = false
                    } else {
                        print("Note is saved successfully in Firebase!")
                        self.session.userSession?.userCalendar.calendarNotes.append(note)
                        self.listOfNotes.array.append(note)
                        self.note = ""
                        self.showWarninig = false
                        self.setupScrollViewHightAndCheckArray()
                        self.disableAddButton = false
                    }
                }
            }
        }
    }
    func setupScrollViewHightAndCheckArray() {
        var noteCounter = 0
        for note in listOfNotes.array {
            if note.notesDate == date {
                noteCounter += 1
            }
        }
        if noteCounter == 0 {
            self.scrollViewHeight = 0
        } else if noteCounter > 0 && noteCounter < 4 {
            self.scrollViewHeight = CGFloat(noteCounter * 35)
        } else {
            self.scrollViewHeight = 150
        }
        self.checkToDeleteArray = Array(repeating: false, count: noteCounter)
    }
    func updateIsCompletedOnNote(note: CalendarNote) {
        if let id = self.session.userSession?.userProfile.userID {
            self.session.updateCalendarNote(userID: id, calendarNote: note)
        }
        note.isCompleted.toggle()
    }
    func deleteNote(note: CalendarNote) {
        if let id = self.session.userSession?.userProfile.userID {
            if let indexForSession = self.session.userSession?.userCalendar.calendarNotes.firstIndex(of: note) {
                self.session.deleteCalendarNoteFromDB(userID: id, note: note)
                self.session.userSession?.userCalendar.calendarNotes.remove(at: indexForSession)
            }
            if let indexForList = self.listOfNotes.array.firstIndex(of: note) {
                self.listOfNotes.array.remove(at: indexForList)
                self.setupScrollViewHightAndCheckArray()
            }
            
        }
    }
}

