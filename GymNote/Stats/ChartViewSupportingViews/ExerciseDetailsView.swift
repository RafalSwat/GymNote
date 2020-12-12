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
    
    var body: some View {
        VStack {
            HStack {
                Text("Best score: ")
                Spacer()
                Text("22")
            }
            .padding(.horizontal)
            
            HStack {
                Text("Average score: ")
                Spacer()
                Text("13")
            }
            .padding(.horizontal)
            
            HStack {
                Text("Average number of series: ")
                Spacer()
                Text("13")
            }
            .padding(.horizontal)
            
            HStack {
                Text("Exercise Frequency: ")
                Spacer()
                Text("0.3")
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(3)
            .shadow(color: Color.black, radius: 1)
            
            HStack {
                Text("trend slope: ")
                Spacer()
                Text("10°")
            }
            .padding(.horizontal)
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

struct ExerciseDetailsView_Previews: PreviewProvider {
    
    @State static var show = true
    
    static var previews: some View {
        ExerciseDetailsView(showExercieDetails: $show)
    }
}
