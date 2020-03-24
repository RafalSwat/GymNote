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
    @State var weight = ""
    @State var rep = ""
    
    var body: some View {
        
        VStack {
            HStack {
                Text("repeats")
                    .offset(x: -55)
                Text("weight")
                    //.offset(x: 15)
                    .offset(x: UIScreen.main.bounds.width/15)
            }
            .font(.subheadline)
            .foregroundColor(.magnesium)
            
            ForEach (0 ..< self.weights.count, id: \.self) { index in
                HStack {
                    SeriesTextFields(repeats: self.$repeats,
                                     weights: self.$weights,
                                     index: index,
                                     reps: self.rep,
                                     weight: self.weight)
                    
                    Button("-", action: {
                        //TODO: decrease numberOfSeries if it is greater then 1, remove elements in arrays
                        print("Delete series button tapped!")
                        self.removeRows(at: index)
                        
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
    
    func removeRows(at offsets: Int) {
        repeats.remove(at: offsets)
        weights.remove(at: offsets)
        numberOfSeries -= 1
    }
    
}

struct ExerciseDetails_Previews: PreviewProvider {
    
    @State static var prevTempExercise = Exercise(name: "example1")
    
    static var previews: some View {
        ExerciseDetails(tempExercise: $prevTempExercise)
    }
}


