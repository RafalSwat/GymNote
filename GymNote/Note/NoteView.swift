//
//  NoteView.swift
//  GymNote
//
//  Created by Rafał Swat on 29/05/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct NoteView: View {
    
    @State var listOfTrainings: [Training]
    @State private var passageToAddTraining = false
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: CreateProgramView(), isActive: self.$passageToAddTraining, label: { Text("") })
                List {
                    ForEach(listOfTrainings, id: \.trainingID) { training in
                        TrainingRow(training: training, listOfTraining: self.$listOfTrainings)
                    }
                    
                }
                AddButton(addButtonText: "Add New Training",
                          action: {print("Add new training tapped!")},
                          addingMode: self.$passageToAddTraining)
                    .padding()
            }
            .navigationBarTitle("Training List")
        }
    }

}
struct NoteView_Previews: PreviewProvider {
    
    static var prevListOfTrainings = [Training(id: UUID().uuidString,
                                               name: "My Training",
                                               subscription: "My litte subscription",
                                               date: "01-Jan-2020",
                                               exercises: [Exercise(name: "My Exercise")])]
    
    static var previews: some View {
        NavigationView {
            NoteView(listOfTrainings: prevListOfTrainings)
        }
    }
}
