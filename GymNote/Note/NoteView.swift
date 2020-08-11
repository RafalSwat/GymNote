//
//  NoteView.swift
//  GymNote
//
//  Created by Rafał Swat on 29/05/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct NoteView: View {
    
    @EnvironmentObject var session: FireBaseSession
    @State private var passageToAddTraining = false
    @State var listOfTrainings = [Training]()
    @State var showDetailsArray = [Bool]()
    @State var showButtonsArray = [Bool]()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(0..<self.listOfTrainings.count, id: \.self) { index in
                        TrainingRow(listOfTrainings: self.$listOfTrainings,
                                    training: self.listOfTrainings[index],
                                    showButtons: self.$showButtonsArray[index],
                                    showDetails: self.$showDetailsArray[index])
                    }
                }
                .onAppear {
                    if let list = self.session.userSession?.userTrainings {
                        self.listOfTrainings = list
                    }
                    self.showDetailsArray = Array(repeating: false, count: (self.session.userSession?.userTrainings.count)!)
                    self.showButtonsArray = Array(repeating: false, count: (self.session.userSession?.userTrainings.count)!)
                }
                AddButton(addButtonText: "Add New Training",
                          action: {},
                          addingMode: self.$passageToAddTraining)
                    .padding()
                
                NavigationLink(destination: TrainingHost(editMode: true, training: Training()), isActive: self.$passageToAddTraining, label: { EmptyView() })
            }
        }
        .navigationBarTitle("Training List")
    }
    
}



struct NoteView_Previews: PreviewProvider {
    
    static var prevListOfTrainings = [Training(id: UUID().uuidString,
                                               name: "My Training",
                                               description: "My litte subscription",
                                               date: "01-Jan-2020",
                                               exercises: [Exercise(name: "My Exercise")])]
    
    static var previews: some View {
        NavigationView {
            NoteView()
        }
    }
}
