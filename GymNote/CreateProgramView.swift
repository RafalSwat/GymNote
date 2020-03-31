//
//  CreateProgramView.swift
//  GymNote
//
//  Created by Rafał Swat on 31/03/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//
import SwiftUI

struct CreateProgramView: View {
    
    @EnvironmentObject var session: FireBaseSession
    @State var addMode = false  //needed to show sheet with exercises
    @State var doneCreating = false // needed to save training
    @State var editMode = true  // needed to display correct "titleBelt"
    @State var selectedExercises = [Exercise]()
    @State var programTitle = ""
    @State var programSubscription = ""
    @State var programImage  = Image("staticImage")
    
    var body: some View {
            VStack {
                DateBelt(lightBeltColors: [.white, .magnesium], darkBeltColors: [.black, .magnesium])
                TitleBelt(title: $programTitle, subtitle: $programSubscription,
                          editMode: $editMode, image: $programImage,
                          lightBeltColors: [.white, .magnesium], darkBeltColors: [.black, .magnesium])
                Divider()
                Spacer()
                if selectedExercises.count != 0 {
                    List {
                        ForEach(0..<selectedExercises.count, id: \.self) { index in
                            TrainingSessionListRow(exercise: self.$selectedExercises[index])
                        }
                    }
                }
                
                AddButton(fromColor: .gray, toColor: .magnesium ,addingMode: $addMode)
                    .padding()
                    .sheet(isPresented: $addMode) {
                        ExercisesListView(finishTyping: self.$addMode, selectedExercises: self.$selectedExercises, buttonColors: [Color.gray, Color.magnesium])
                }
                
            }
            .navigationBarTitle("Create Program", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: BackButton(),
                trailing: DoneButton(isDone: $doneCreating)
            )
    }
    
}

struct CreateProgramView_Previews: PreviewProvider {
    
    @State static var session = FireBaseSession()
    
    static var previews: some View {
        CreateProgramView()
            .environmentObject(session)
    }
}
