//
//  TrainingView.swift
//  GymNote
//
//  Created by Rafał Swat on 20/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct TrainingView: View {
    
    var training: Training
    
    
    var body: some View {
        VStack {
            List {
                ForEach(training.listOfExercises, id: \.self) { exercise in
                    ExerciseView(exercise: exercise)
                }
            }
        }
        .navigationBarTitle(training.trainingName)
    }
}

struct TrainingView_Previews: PreviewProvider {
    
    static var prevTraining = Training()
    
    static var previews: some View {
        NavigationView {
            TrainingView(training: prevTraining)
        }
    }
}
