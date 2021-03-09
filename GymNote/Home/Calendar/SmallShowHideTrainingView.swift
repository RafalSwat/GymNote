//
//  SmallShowHideTrainingView.swift
//  GymNote
//
//  Created by Rafał Swat on 09/03/2021.
//  Copyright © 2021 Rafał Swat. All rights reserved.
//

import SwiftUI

struct SmallShowHideTrainingView: View {
    
    @State private var showDetails = false
    var training: TrainingSession
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.showDetails.toggle()
                }, label: {
                    HStack {
                        if showDetails {
                            Image(systemName: "eye.slash")
                                .foregroundColor(.orange)
                                .font(.title)
                        } else {
                            Image(systemName: "eye")
                                .foregroundColor(.orange)
                                .font(.title)
                        }
                        
                        
                        Text(training.trainingName)
                            .multilineTextAlignment(.leading)
                            .font(.title)
                            .foregroundColor(.orange)
                            
                        Spacer()
                    }.shadow(color: .black, radius: 1, x: -1, y: 1)
                }).buttonStyle(BorderlessButtonStyle())
                ChaveronDeleteComplexButtons(deleteAction: {
                    //
                })
            }
            HStack {
                Text("      ")
                    .font(.largeTitle)
                Text(training.trainingDescription)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
        }
    }
}

