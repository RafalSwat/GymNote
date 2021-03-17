//
//  MainContainer.swift
//  GymNote
//
//  Created by Rafał Swat on 29/05/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct MainContainer: View {
    @EnvironmentObject var session: FireBaseSession
    @State private var selected = 0
    @Binding var alreadySignIn: Bool
    
    //MARK: variables coresponding to StatsView (bug workaround)
    @State var statsLoadedSuccessfully: Bool? = nil
    @StateObject var listOfExerciseStatistic: ObservableArray<ExerciseStatistics> = ObservableArray(array: [ExerciseStatistics]()).observeChildrenChanges()
    
    var body: some View {
        
        TabView(selection: $selected) {
            HomeView(alreadySignIn: $alreadySignIn)
                .tabItem {
                    VStack {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .font(.largeTitle)
                    .padding()
                }.tag(0)
            
            NoteView()
                .tabItem {
                    VStack {
                        Image(systemName: "pencil.and.ellipsis.rectangle")
                        Text("Note")
                    }
                    .font(.largeTitle)
                    .padding()
                }.tag(1)
            
            
            ChartView(listOfExerciseStatistic: listOfExerciseStatistic, statsLoadedSuccessfully: $statsLoadedSuccessfully)
                .onAppear {
                    self.setupUserStatisticsIfNeeded()
                }
                .tabItem {
                    VStack {
                        Image(systemName: "waveform.path.ecg")
                        Text("Stats")
                    }
                    .font(.largeTitle)
                    .padding()
                }.tag(2)
            
            
        }
        .accentColor(Color.orange)
        .navigationBarBackButtonHidden(true)
        
        
    }
    //MARK: This is here becouse of bug related to onAppear and onDisappear combine navigationView and TapView
    
    func setupUserStatisticsIfNeeded() {
        if self.session.userSession?.userStatistics.count == 0 {
            self.session.downloadUserStatisticsFromDB(userID: (session.userSession?.userProfile.userID)!, completion: { finishedLoadingStats in
                if finishedLoadingStats && self.session.userSession?.userStatistics.count == 0 {
                    self.listOfExerciseStatistic.array = [ExerciseStatistics]()
                    self.statsLoadedSuccessfully = false
                    //self.didAppear = true
                } else if finishedLoadingStats && self.session.userSession?.userStatistics.count != 0 {
                    self.listOfExerciseStatistic.array = self.session.userSession!.userStatistics
                    self.statsLoadedSuccessfully = true
                    //self.didAppear = true
                }
            })
        } else {
            self.listOfExerciseStatistic.array = self.session.userSession?.userStatistics ?? [ExerciseStatistics]()
            self.statsLoadedSuccessfully = true
            //self.didAppear = true
        }
    }
    
}
@available(iOS 14.0, *)
struct MainContainer_Previews: PreviewProvider {
    
    @State static var session = FireBaseSession()
    @State static var prevAlreadySignIn = true
    
    static var previews: some View {
        MainContainer(alreadySignIn: $prevAlreadySignIn).environmentObject(session)
    }
}
