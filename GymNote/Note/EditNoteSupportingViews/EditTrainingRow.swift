//
//  EditTrainingRow.swift
//  GymNote
//
//  Created by Rafał Swat on 10/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct EditTrainingRow: View {
    
    @Binding var training: Training
    
    var body: some View {
        HStack(spacing: 15) {
            Button(action: {
                print("Delete Action!")
            }) {
                Image(systemName: "trash")
                    .font(.title)
            }
            
            VStack(alignment: .leading) {
                Text(training.trainingName)
                Text(training.trainingSubscription)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            
            Button(action: {
                print("Go To Details Action!")
            }) {
                Image(systemName: "chevron.right")
                    .font(.title)
            }
            
        }.buttonStyle(PlainButtonStyle())
    }
}

struct EditTrainingRow_Previews: PreviewProvider {
    
    @State static var prevTraining = Training()
    
    static var previews: some View {
        EditTrainingRow(training: $prevTraining)
    }
}
