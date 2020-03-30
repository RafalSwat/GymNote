//
//  TrainingSessionView.swift
//  GymNote
//
//  Created by Rafał Swat on 01/03/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct TrainingSessionView: View {
    
    @EnvironmentObject var session: FireBaseSession
    @State var addMode = false  //needed to show sheet with exercises
    @State var doneCreating = false // needed to save training
    @State var editMode = true  // needed to display correct "titleBelt"
    @State var selectedExercises = [Exercise]()
    @State var trainingTitle = ""
    @State var trainingSubscription = ""
    @State var trainingImage  = Image("staticImage")
    
    var body: some View {
        
    }
    
    func saveTrainingOffline() {
        let training = Training(name: trainingTitle,
                                subscription: trainingSubscription,
                                date: DateConverter.dateFormat.string(from: Date()),
                                exercises: selectedExercises)
        self.session.userSession?.userTrainings?.listOfTrainings.append(training)
    }
}

struct TrainingSessionView_Previews: PreviewProvider {
    
    @State static var session = FireBaseSession()
    @State static var prevSelectedExercise = [Exercise]()
    
    static var previews: some View {
        NavigationView {
            TrainingSessionView(selectedExercises: prevSelectedExercise)
                .environmentObject(session)
        }
        
    }
}
