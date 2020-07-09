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
    @Binding var list: [Exercise]
    
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
                            let newExercise = Exercise(name: self.exerciseName, isCheck: self.isCheck)
                            self.list.insert(newExercise, at: self.list.startIndex)
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
}

struct AddUserExerciseView_Previews: PreviewProvider {
    
    @State static var prevList = [Exercise]()
    @State static var prevShowAddView = true
    
    static var previews: some View {
        AddUserExerciseView(showAddView: $prevShowAddView, list: $prevList)
    }
}
