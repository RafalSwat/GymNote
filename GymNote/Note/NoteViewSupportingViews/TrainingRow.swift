//
//  TrainingRow.swift
//  GymNote
//
//  Created by Rafał Swat on 08/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct TrainingRow: View {
    
    var training: Training
    @State var showDetails = false
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation { self.showDetails.toggle() }
            }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(training.trainingName)
                            .font(.headline)
                        
                        Text(training.trainingSubscription)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    
                    Spacer()
                    if showDetails {
                        Image(systemName: "chevron.up")
                            .font(.callout)
                    } else {
                        Image(systemName: "chevron.down")
                            .font(.callout)
                    }
                }
            }
            if showDetails {
                TrainingDetails(training: training)
            }
        }
    }
}


struct TrainingRow_Previews: PreviewProvider {
    
    static var prevTraining = Training(id: UUID().uuidString,
                                       name: "My Program",
                                       subscription: "My litte subscription ",
                                       date: "01-Jan-2020",
                                       exercises: [Exercise(name: "My Exercise")])
    static var previews: some View {
        TrainingRow(training: prevTraining)
    }
}
