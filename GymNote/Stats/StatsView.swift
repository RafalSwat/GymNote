//
//  StatsView.swift
//  GymNote
//
//  Created by Rafał Swat on 07/08/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct StatsView: View {
    
    @State var exerciseStatistics = [ExerciseStatistics]()
    
    var body: some View {
        VStack {
            List {
                ForEach(exerciseStatistics, id: \.exerciseID) { exercise in
                    VStack {
                        HStack {
                            Text(exercise.exerciseName)
                        }
                    }
                }
            }
            .onAppear {
                self.setupTempExerciseList()
            }
        }
    }
    func setupTempExerciseList() {
        for _ in 0..<10 {
            let stats = ExerciseStatistics()
            self.exerciseStatistics.append(stats)
        }
    }
    
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
