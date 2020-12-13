//
//  ExerciseDetailsView.swift
//  GymNote
//
//  Created by Rafał Swat on 12/12/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ExerciseDetailsView: View {
    
    @Binding var showExercieDetails: Bool
    @Binding var chosenStats: LineChartModelView?
    @Binding var chartCase: ChartCase
    
    @State var hightlightIndex: Int?
    
    var body: some View {
        if chosenStats == nil {
            Indicator()
        } else {
            VStack {
                HStack {
                    if self.chartCase == .repetition {
                        Text("The greates number of repetitions: ")
                        Spacer()
                        Text("\(chosenStats!.theGreatestNumberOfRepetitions, specifier: "%.2f")")
                    } else {
                        Text("The greates weight: ")
                        Spacer()
                        Text("\(chosenStats!.theGratestWeight, specifier: "%.2f")")
                    }
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .background(self.hightlightIndex == 0 ? LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: .leading, endPoint: .trailing) : LinearGradient(gradient: Gradient(colors: [.customLight, .customSuperLight]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(self.hightlightIndex == 0 ? 3 : 0)
                .shadow(color: self.hightlightIndex == 0 ? Color.black : Color(UIColor.systemGroupedBackground),
                        radius: self.hightlightIndex == 0 ? 1 : 0)
                .onTapGesture {
                    withAnimation {
                        self.hightlightIndex = 0
                    }
                }
                
                HStack {
                    if self.chartCase == .repetition {
                        Text("Average number of repetitions: ")
                        Spacer()
                        Text("\(self.chosenStats!.theAverageNumberOfRepetitions, specifier: "%.2f")")
                    } else {
                        Text("Average weight: ")
                        Spacer()
                        Text("\(self.chosenStats!.theAverageWeight, specifier: "%.2f")")
                    }
                    
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .background(self.hightlightIndex == 1 ? LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: .leading, endPoint: .trailing) : LinearGradient(gradient: Gradient(colors: [.customLight, .customSuperLight]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(self.hightlightIndex == 1 ? 3 : 0)
                .shadow(color: self.hightlightIndex == 1 ? Color.black : Color(UIColor.systemGroupedBackground),
                        radius: self.hightlightIndex == 1 ? 1 : 0)
                .onTapGesture {
                    withAnimation {
                        self.hightlightIndex = 1
                    }
                }
                
                HStack {
                    Text("Average number of series: ")
                    Spacer()
                    Text("\(self.chosenStats!.averageNumberOfSeries, specifier: "%.2f")")
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .background(self.hightlightIndex == 2 ? LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: .leading, endPoint: .trailing) : LinearGradient(gradient: Gradient(colors: [.customLight, .customSuperLight]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(self.hightlightIndex == 2 ? 3 : 0)
                .shadow(color: self.hightlightIndex == 2 ? Color.black : Color(UIColor.systemGroupedBackground),
                        radius: self.hightlightIndex == 2 ? 1 : 0)
                .onTapGesture {
                    withAnimation {
                        self.hightlightIndex = 2
                    }
                }
                
                HStack {
                    Text("Exercise Frequency: ")
                    Spacer()
                    Text("\(self.chosenStats!.exerciseFrequency, specifier: "%.2f")")
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .background(self.hightlightIndex == 3 ? LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: .leading, endPoint: .trailing) : LinearGradient(gradient: Gradient(colors: [.customLight, .customSuperLight]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(self.hightlightIndex == 3 ? 3 : 0)
                .shadow(color: self.hightlightIndex == 3 ? Color.black : Color(UIColor.systemGroupedBackground),
                        radius: self.hightlightIndex == 3 ? 1 : 0)
                .onTapGesture {
                    withAnimation {
                        self.hightlightIndex = 3
                    }
                }
                
                HStack {
                    Text("trend slope: ")
                    Spacer()
                    Text("10°")
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .background(self.hightlightIndex == 4 ? LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: .leading, endPoint: .trailing) : LinearGradient(gradient: Gradient(colors: [.customLight, .customSuperLight]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(self.hightlightIndex == 4 ? 3 : 0)
                .shadow(color: self.hightlightIndex == 4 ? Color.black : Color(UIColor.systemGroupedBackground),
                        radius: self.hightlightIndex == 4 ? 1 : 0)
                .onTapGesture {
                    withAnimation {
                        self.hightlightIndex = 4
                    }
                }
            }
            
            .padding(.vertical, 5)
            .font(.callout)
            .contentShape(Rectangle())
            .frame(maxWidth: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [.customLight, .customSuperLight]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(5)
            .shadow(color: Color.customShadow, radius: 1)
            .padding(.horizontal, 5)
        }
    }
}

struct ExerciseDetailsView_Previews: PreviewProvider {
    
    @State static var show = true
    @State static var  stats: LineChartModelView?
    @State static var chartCase = ChartCase.repetition
    
    static var previews: some View {
        ExerciseDetailsView(showExercieDetails: $show, chosenStats: $stats, chartCase: $chartCase)
    }
}
