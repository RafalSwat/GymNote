//
//  EditNoteView.swift
//  GymNote
//
//  Created by Rafał Swat on 08/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct EditNoteView: View {
    
    @EnvironmentObject var session: FireBaseSession
    @Binding var listOfTrainings: [Training]
    @State var passageToAddTraining = false
    
    var body: some View {
        
        VStack {
            NavigationLink(destination: CreateProgramView(), isActive: self.$passageToAddTraining, label: { Text("") })
            
            List {
                ForEach(listOfTrainings, id: \.trainingID) { training in
                    EditTrainingRow(training: training)
                }
            }
        }.navigationBarTitle("Edit List")
    }
}

struct EditNoteView_Previews: PreviewProvider {
    
    @State static var prevListOfTrainings = [Training(id: UUID().uuidString,
                                               name: "My Training",
                                               subscription: "My litte subscription",
                                               date: "01-Jan-2020",
                                               exercises: [Exercise(name: "My Exercise")])]
    
    
    static var previews: some View {
        NavigationView {
            EditNoteView(listOfTrainings: $prevListOfTrainings)
        }
    }
}
