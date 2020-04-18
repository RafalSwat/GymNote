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
        ZStack {
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
                            CreateProgramListRow(exercise: self.$selectedExercises[index])
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
            if (doneCreating) {
                ZStack {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.vertical)
                    GeometryReader { geometry in
                        DoneConformAlert(showAlert: self.$doneCreating, alertTitle: "", alertMessage: "MESS", alertAction: {
                            self.saveProgram()
                            self.doneCreating.toggle()
                            
                        })
                            .padding()
                            .position(x: geometry.size.width/2, y: geometry.size.height/2)
                    }
                }
            }
        }
    }
    func saveProgram() {
        let training = Training(name: programTitle,
                                subscription: programSubscription,
                                date: DateConverter.dateFormat.string(from: Date()),
                                exercises: selectedExercises)
        self.session.userSession?.userTrainings?.listOfTrainings.append(training)
        
        //saving on firebase
        self.session.addTrainingToFBR(userTrainings: (self.session.userSession?.userTrainings)!, training: training)
    }
}

struct CreateProgramView_Previews: PreviewProvider {
    
    @State static var session = FireBaseSession()
    
    static var previews: some View {
        NavigationView {
            CreateProgramView()
            .environmentObject(session)
        }
        
    }
}
