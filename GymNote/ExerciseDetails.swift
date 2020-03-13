//
//  ExerciseDetails.swift
//  GymNote
//
//  Created by Rafał Swat on 11/03/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ExerciseDetails: View {
    
    @Binding var numberOfSeries: Int
    @Binding var tempExercise: Exercise
    @State var repeats = [String]()
    @State var weights = [String]()
    
    
    func addSeriesToExercise() {
        self.tempExercise.exerciseSeries = setSeries(seriesNumber: numberOfSeries)
    }
    
    func setSeries(seriesNumber: Int) -> [Series] {
        var tempSeries = [Series]()
        let repeatsAsInt = convertArrayToInt(arrayString: self.repeats)
        let weightsAsInt = convertArrayToInt(arrayString: self.weights)
        
        for index in (0..<seriesNumber) {
            tempSeries.append(Series(repeats: repeatsAsInt[index], weight: weightsAsInt[index]))
        }
        return tempSeries
    }
    
    func convertArrayToInt(arrayString: [String]) -> [Int] {
        var arrayInt: Array<Int> = Array()
        
        for stringElement in arrayString {
            arrayInt.append(Int(stringElement) ?? 0)
        }
        return arrayInt
    }
    
    var body: some View {
        HStack {
            VStack {
                Text("repeats")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Form {
                    ForEach (0 ..< self.numberOfSeries) { number in
                        TextField("...", text: self.$repeats[number])
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                }
                
            }
            VStack {
                Text("weight")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Form {
                    ForEach (0 ..< self.numberOfSeries) { number in
                        TextField("...", text: self.$weights[number])
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                }
                
            }
        }.onDisappear(perform: addSeriesToExercise)
    }
}

struct ExerciseDetails_Previews: PreviewProvider {
    
    @State static var prevNumberOfSeries = 5
    @State static var prevTempExercise = Exercise(name: "example1")
    
    static var previews: some View {
        ExerciseDetails(numberOfSeries: $prevNumberOfSeries, tempExercise: $prevTempExercise)
    }
}
