//
//  NoteView.swift
//  GymNote
//
//  Created by Rafał Swat on 29/05/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct NoteView: View {
    
    @EnvironmentObject var session: FireBaseSession
    @State private var passageToAddTraining = false
    @StateObject var listOfTrainings: ObservableArray<Training> = ObservableArray(array: [Training]()).observeChildrenChanges()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
//                    ForEach(0..<self.listOfTrainings.array.count, id: \.self) { index in
//                        TrainingRow(listOfTrainings: self.listOfTrainings,
//                                    training: self.listOfTrainings.array[index],
//                                    showButtons: self.$showButtonsArray[index],
//                                    showDetails: self.$showDetailsArray[index])
//                    }
                    ForEach(self.listOfTrainings.array, id: \.trainingID) { training in
                        TrainingRow(listOfTrainings: self.listOfTrainings,
                                    training: training)
                        
                    }
                    
                }
                .listStyle(GroupedListStyle())
                .onAppear {
                    if let list = self.session.userSession?.userTrainings {
                        self.listOfTrainings.array = list
                    }
                }
                AddButton(addButtonText: "Add New Training",
                          action: {},
                          addingMode: self.$passageToAddTraining)
                    .padding()
                
                NavigationLink(destination: TrainingHost(editMode: true, training: Training()), isActive: self.$passageToAddTraining, label: { EmptyView() })
            }
            .navigationBarTitle("Training List")
        }
        
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
            if #available(iOS 14.0, *) {
                NoteView()
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
