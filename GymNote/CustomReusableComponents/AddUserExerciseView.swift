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
                .background(LinearGradient(gradient: Gradient(colors: [.red, .orange]), startPoint: .leading, endPoint: .trailing))
                .foregroundColor(Color.white)
                .font(.headline)
            
            
            
            
            TextField("exercise name", text: $exerciseName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Group {
                    Button("Cancel", action:{
                        self.showAddView = false
                    })
                        .buttonStyle(RectangularButtonStyle(fromColor: .red, toColor: .customDark))
                        .shadow(color: Color(UIColor.black),radius: 3)
                        .padding()
                    
                    Button("Add", action: {
                        let newExercise = Exercise(name: self.exerciseName, isCheck: self.isCheck)
                        self.list.append(newExercise)
                    })
                        .buttonStyle(RectangularButtonStyle(fromColor: .green, toColor: .customDark))
                        .shadow(color: Color(UIColor.black),radius: 3)
                        .padding()
                }.padding()
            }
        }
        .cornerRadius(15)
        
    }
    
    func addExerciseToList(name: String, isCheck: Bool) {
        let newExercise = Exercise(name: name, isCheck: isCheck)
        self.list.append(newExercise)
    }
}

struct AddUserExerciseView_Previews: PreviewProvider {
    
    @State static var prevList = [Exercise]()
    @State static var prevShowAddView = true
    
    static var previews: some View {
        AddUserExerciseView(showAddView: $prevShowAddView, list: $prevList)
    }
}
