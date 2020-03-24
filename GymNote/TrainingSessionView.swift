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
        
        VStack {
            DateBelt()
            TitleBelt(title: $trainingTitle, subtitle: $trainingSubscription, editMode: $editMode, image: $trainingImage)
            Divider()
            Spacer()
            if selectedExercises.count != 0 {
                List {
                    ForEach(0..<selectedExercises.count, id: \.self) { index in
                        TrainingSessionListRow(exercise: self.$selectedExercises[index])
                    }
                }
            }
            
            AddButton(addingMode: $addMode)
                .padding()
                .sheet(isPresented: $addMode) {
                    ExercisesListView(finishTyping: self.$addMode, selectedExercises: self.$selectedExercises)
            }
            
        }
        .navigationBarTitle("Edit Profile", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: BackButton(),
            trailing: DoneButton(isDone: $doneCreating)
        )
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
