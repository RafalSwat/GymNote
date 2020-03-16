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
    
    var body: some View {
        
        HStack {
            VStack {
                Text("repeats")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                ForEach (0 ..< self.repeats.count, id: \.self) { index in
                    TextField("...", text: self.$repeats[index])
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
            }
            VStack {
                Text("weight")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                ForEach (0 ..< self.weights.count, id: \.self) { index in
                    TextField("...", text: self.$weights[index])
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
            }
        }.onAppear() {
            self.repeats = Array(repeating: "", count: self.numberOfSeries)
            self.weights = Array(repeating: "", count: self.numberOfSeries)
        }
        
    }
    
    //MARK: Functions
    
    func addSeriesToExercise() {
        self.tempExercise.exerciseSeries = setSeries()
    }
    
    func setSeries() -> [Series] {
        var tempSeries = [Series]()
        let repeatsAsInt = convertArrayToInt(arrayString: self.repeats)
        let weightsAsInt = convertArrayToInt(arrayString: self.weights)
        
        for index in (0..<self.numberOfSeries) {
            print(self.numberOfSeries)
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
}

struct ExerciseDetails_Previews: PreviewProvider {
    
    @State static var prevNumberOfSeries = 1
    @State static var prevTempExercise = Exercise(name: "example1")
    
    static var previews: some View {
        ExerciseDetails(numberOfSeries: $prevNumberOfSeries, tempExercise: $prevTempExercise)
    }
}


