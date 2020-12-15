//
//  ChangeButton.swift
//  GymNote
//
//  Created by Rafał Swat on 11/01/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ChangeButton: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Binding var isChanged: Bool
    
    var changesButtonImage: Image = Image(systemName: "arrow.uturn.left.square")

    var body: some View {
        
        Button(action: {
            self.isChanged.toggle()
        }) {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [.customLight, .customDark]), startPoint: .bottomLeading, endPoint: .topTrailing))
                .cornerRadius(10)
                .shadow(color: colorScheme == .light ? .white : .black, radius: 3)
                .frame(width: 50, height: 50, alignment: .center)
                .overlay(self.changesButtonImage
                            .font(.largeTitle)
                            .foregroundColor(Color.orange))
            
                
            
        }
        
    }
}

struct ChangeButton_Previews: PreviewProvider {
    
    @State static var prevIsChanged = false
    
    static var previews: some View {
        ChangeButton(isChanged: $prevIsChanged)
    }
}
