//
//  ExerciseDetails.swift
//  GymNote
//
//  Created by Rafał Swat on 11/03/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ExerciseDetails: View {
    
    @Binding var tempExercise: Exercise
    @State var numberOfSeries = 1
    @State var repeats = [String]()
    @State var weights = [String]()
    
    var body: some View {
        
        VStack {
            HStack {
                Text("repeats")
                    .offset(x: -55)
                Text("weight")
                    .offset(x: 10)
            }
            .font(.subheadline)
            .foregroundColor(.magnesium)
            
            ForEach (0 ..< self.weights.count, id: \.self) { index in
                HStack {
                    TextField("...", text: self.$weights[index])
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    TextField("...", text: self.$repeats[index])
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    Button("-", action: {
                        //TODO: decrease numberOfSeries if it is greater then 1, remove elements in arrays
                        print("Delete series button tapped!")
                    })
                        .buttonStyle(RectangularButtonStyle(
                            fromColor: .black,
                            toColor: .red,
                            minWidth: 10, maxWidth: 25,
                            minHeight:10, maxHeight: 20))
                }
            }
            
            Button("add series", action: {
                self.numberOfSeries += 1
                self.repeats.append("")
                self.weights.append("")
            }).buttonStyle(RectangularButtonStyle(fromColor: .black, toColor: .green,
                                                           minHeight: 10, maxHeight: 25))
                
            
            
            
        }
        .onAppear() {
            self.repeats = Array(repeating: "", count: self.numberOfSeries)
            self.weights = Array(repeating: "", count: self.numberOfSeries)
        }
        .padding(.horizontal)
        .padding(.bottom)
        .background(LinearGradient(gradient: Gradient(
            colors: [.gray ,.customDark]),
                                   startPoint: .leading, endPoint: .trailing
        ))
        
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
    
    @State static var prevTempExercise = Exercise(name: "example1")
    
    static var previews: some View {
        ExerciseDetails(tempExercise: $prevTempExercise)
    }
}


