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
        ZStack {
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
            .navigationBarTitle("Training Session", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: BackButton(),
                trailing: DoneButton(isDone: $doneCreating)
            )
            if (doneCreating) {
                ZStack {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.vertical)
                    GeometryReader { geometry in
                        DoneConformAlert(showAlert: self.$doneCreating, alertTitle: "", alertMessage: "MESS", alertAction: {
                            self.saveTraining()
                            self.doneCreating.toggle()
                            
                        })
                            .padding()
                            .position(x: geometry.size.width/2, y: geometry.size.height/2)
                    }
                }
            }
        }
        
    }
    
    func saveTraining() {
        let training = Training(name: trainingTitle,
                                subscription: trainingSubscription,
                                date: DateConverter.dateFormat.string(from: Date()),
                                exercises: selectedExercises)
        self.session.userSession?.userTrainings?.listOfTrainings.append(training)
        
        //saving on firebase
        self.session.addTrainingToFBR(userTrainings: (self.session.userSession?.userTrainings)!, training: training)
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
