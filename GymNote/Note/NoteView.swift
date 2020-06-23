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
    let newTraining = Training()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(listOfTrainings, id: \.trainingID) { training in
                        TrainingRow(training: training, listOfTraining: self.$listOfTrainings)
                    }
                    
                }
                AddButton(addButtonText: "Add New Training",
                          action: {},
                          addingMode: self.$passageToAddTraining)
                    .padding()
                
                NavigationLink(destination: TrainingHost(editMode: true, training: newTraining), isActive: self.$passageToAddTraining, label: { EmptyView() })
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
