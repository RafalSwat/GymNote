//
//  NoteView.swift
//  GymNote
//
//  Created by Rafał Swat on 29/05/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct NoteView: View {
    
    @State var listOfTrainings = [Training(id: UUID().uuidString,
                                           name: "My Training",
                                           subscription: "My litte subscription",
                                           date: "01-Jan-2020",
                                           exercises: [Exercise(name: "My Exercise")])]
    @State private var passageToAddTraining = false
    
    var body: some View {
        
        VStack {
            
            NavigationLink(destination: CreateProgramView(), isActive: self.$passageToAddTraining, label: { Text("") })
            
            List(listOfTrainings, id: \.trainingID) { training in
                Text(training.trainingName)
            }
            AddButton(addButtonText: "Add New Training",
                      action: {print("Add new training tapped!")},
                      addingMode: self.$passageToAddTraining)
                .padding()
        }
        .navigationBarTitle("Training List")
    }
}

struct NoteView_Previews: PreviewProvider {
    
    @State static var prevListOfTrainings = [Training(id: UUID().uuidString,
                                                      name: "My Training",
                                                      subscription: "My litte subscription",
                                                      date: "01-Jan-2020",
                                                      exercises: [Exercise(name: "My Exercise")])]
    
    static var previews: some View {
        NoteView()
    }
}
