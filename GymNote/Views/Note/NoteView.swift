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
    @State var listOfTrainings = [Training]()
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
        .onAppear {
            if self.session.userSession != nil {
                self.listOfTrainings = self.session.userSession!.userTrainings.listOfTrainings
            }
        }
    }

}
struct NoteView_Previews: PreviewProvider {
    

    
    static var previews: some View {
        NavigationView {
            NoteView()
        }
    }
}
