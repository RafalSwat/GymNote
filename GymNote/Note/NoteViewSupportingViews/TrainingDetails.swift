//
//  TrainingDetails.swift
//  GymNote
//
//  Created by Rafał Swat on 08/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct TrainingDetails: View {
    
    var training: Training
    
    var body: some View {

        ForEach(training.listOfExercises) { trainingsComponent in
            HStack {
                Text(trainingsComponent.exercise.exerciseName)
                Spacer()
                Text("series:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(String(trainingsComponent.exerciseNumberOfSeries))
            }
        }
    }
}

