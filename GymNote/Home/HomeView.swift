//
//  HomeView.swift
//  GymNote
//
//  Created by Rafał Swat on 06/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct HomeView: View {
    
    
    @EnvironmentObject var session: FireBaseSession
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.calendar) var calendar
    
    @Binding var alreadySignIn: Bool
    @State var isAnonymous: Bool? = nil
    @State var showProfile = false
    @State var goToSignIn = false
    @State var showAlert = false
    
    @State var selectedDate = Date()
    @State var components = DateComponents()
    @State var showDayView = false
    private var year: DateInterval {
        calendar.dateInterval(of: .year, for: Date())!
    }
    @StateObject var listOfNotes: ObservableArray<CalendarNote> = ObservableArray(array: [CalendarNote]()).observeChildrenChanges()
    @StateObject var listOfTrainings: ObservableArray<Training> = ObservableArray(array: [Training]()).observeChildrenChanges()
    
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    
                    NavigationLink(destination: ProfileHost(alreadySignIn: $alreadySignIn), isActive: self.$showProfile, label: {EmptyView()})
                    NavigationLink(destination: SignUpPopUpView(goToSignIn: $goToSignIn, alreadySignIn: $alreadySignIn, showAlert: $showAlert), isActive: self.$goToSignIn, label: {EmptyView()})
                    
                    CalendarView(interval: year) { date in
                        CalendarCellView(date: date,
                                         trainingDay: isTrainingDay(date: date),
                                         notesDay: isDayWithNote(date: date),
                                         isIncompltedTask: areThereIncompleteTasks(forDay: date))
                        
                            .onTapGesture {
                                self.setUpSelectedDate(date: date)
                                self.showDayView.toggle()
                            }
                    }
                    .padding(10)
                    
                }
                if showDayView {
                    Color.black.opacity(0.7)
                        .onTapGesture {
                            self.showDayView.toggle()
                        }
                    
                    CalendarDayView(listOfTrainingSessions: self.listOfTrainings,
                                    listOfNotes: self.listOfNotes,
                                    date: self.$selectedDate)
                        .padding(.horizontal, 30)
                        
                }
                
            }
            .navigationBarItems(leading: SignOutButton(signIn: $alreadySignIn), trailing: ProfileButton(showProfile: self.$showProfile, goToSignIn: self.$goToSignIn))
            .navigationBarTitle("Home", displayMode: .inline)
            .onAppear {
                self.setUpCalendarArrays()
                print("--------- on appear home -----------")
            }
            
        }
    }
    func isTrainingDay(date: Date) -> Bool {
        for training in listOfTrainings.array {
            if training.trainingDates.contains(where: {$0 == date }) {
                return true
            }
        }
        return false
    }
    func isDayWithNote(date: Date) -> Bool {
        for note in listOfNotes.array {
            if note.notesDate == date {
                return true
            }
        }
        return false
    }
    func areThereIncompleteTasks(forDay: Date) -> Bool {
        var notes = [CalendarNote]()
        
        for note in listOfNotes.array {
            if note.notesDate == forDay {
                notes.append(note)
            }
        }
        if notes.contains(where: {$0.isCompleted == false}) {
            return true
        } else {
            return false
        }
    }
    
    func setUpSelectedDate(date: Date) {
        self.components.minute = 0
        self.components.hour = 0
        self.components.day = self.calendar.component(.day, from: date)
        self.components.month = self.calendar.component(.month, from: date)
        self.components.year = self.calendar.component(.year, from: date)
        
        self.selectedDate = self.calendar.date(from: self.components) ?? Date()
    }
    func setUpCalendarArrays() {

            if let userID = self.session.userSession?.userProfile.userID {
                self.session.downloadTrainingsFromDB(userID: userID) { finishDownloading in
                    if finishDownloading {
                        if let list = self.session.userSession?.userTrainings {
                            self.listOfTrainings.array = list
                        }
                    }
                }
                self.session.downloadCalendarNote(userID: userID) { (notesDownloadedSucccessfull) in
                    if notesDownloadedSucccessfull {
                        self.listOfNotes.array = (self.session.userSession?.userCalendar)!
                    }
                }
            }
        
    }
}



