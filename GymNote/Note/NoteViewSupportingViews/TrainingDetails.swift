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

        ForEach(training.listOfExercises) { exercise in
            HStack {
                Text(exercise.exerciseName)
                Spacer()
                Text("series:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(String(exercise.exerciseNumberOfSeries))
            }
        }
    }
}

struct TrainingDetails_Previews: PreviewProvider {
    
    static var prevTraining = Training(id: UUID().uuidString,
                                       name: "My Program",
                                       description: "My litte subscription ",
                                       date: "01-Jan-2020",
                                       exercises: [Exercise(name: "My Exercise")])
    
    static var previews: some View {
        TrainingDetails(training: prevTraining)
    }
}
