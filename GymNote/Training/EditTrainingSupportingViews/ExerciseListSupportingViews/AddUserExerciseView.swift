//
//  AddUserExerciseView.swift
//  GymNote
//
//  Created by Rafał Swat on 09/03/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct AddUserExerciseView: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var exerciseName = ""
    @State var isCheck = true
    @Binding var showAddView: Bool
    @Binding var list: [TrainingsComponent]
    
    var body: some View {
        VStack {
            
            Text("Enter the name of your own, new exercise to the list: ")
                .multilineTextAlignment(.center)
                .lineLimit(2).fixedSize(horizontal: false, vertical: true)
                .padding(.vertical, 5)
                .frame(maxWidth: .infinity)
                .foregroundColor(colorScheme == .light ? Color.secondary : Color.magnesium)
                .font(.headline)
            
            
            HStack {
                TextField("exercise name", text: $exerciseName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    if self.exerciseName != "" {
                        withAnimation {
                            let newComponent = TrainingsComponent(exercise: Exercise(id: UUID().uuidString,
                                                                                    name: self.exerciseName,
                                                                                    createdByUser: true),
                                                                 numberOfSeries: 1,
                                                                 orderInList: 1)
                            self.addTrainingSafely(trainingComponent: newComponent)
                            self.exerciseName = ""
                            self.showAddView = false
                        }
                    } else {
                        withAnimation {
                            self.showAddView = false
                        }
                    }
                }) {
                    Image(systemName: "checkmark.square")
                        .font(.largeTitle)
                        .foregroundColor(colorScheme == .light ? Color.secondary : Color.magnesium)
                }
            }.padding()
        }.background(colorScheme == .light ? Color.magnesium :  Color.customDark)
    }
    func addTrainingSafely(trainingComponent: TrainingsComponent) {
        self.list.insert(trainingComponent, at: self.list.startIndex)
        sleep(1) // dont know why but error occur when user tapeed addbutton to quickly
    }
}

struct AddUserExerciseView_Previews: PreviewProvider {
    
    @State static var prevList = [TrainingsComponent]()
    @State static var prevShowAddView = true
    
    static var previews: some View {
        AddUserExerciseView(showAddView: $prevShowAddView, list: $prevList)
    }
}
