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
    @State var addMode = false
    @State var doneCreating = false
    @State var selectedExercises = [Exercise]()
    
    var body: some View {
        
        VStack {
            DateBelt()
            TitleBelt(title: "...", subtitle: "...", editMode: true)
            Divider()
            Spacer()
            List(selectedExercises, id: \.self) { exercise in
                Text(exercise.exerciseName)
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
    
    static var previews: some View {
        TrainingSessionView()
            .environmentObject(session)
    }
}
