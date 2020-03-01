//
//  DoneButton.swift
//  GymNote
//
//  Created by Rafał Swat on 11/01/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//


import SwiftUI

struct DoneButton: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Binding var isDone: Bool
    
    var changesButtonImage: Image = Image(systemName: "checkmark.circle")

    var body: some View {
        
        Button(action: {
            
            self.isDone.toggle()

        }) {
            self.changesButtonImage
                .font(.largeTitle)
                .foregroundColor(colorScheme == .light ? .black : .secondary)
        }
    }
}

struct DoneButton_Previews: PreviewProvider {
    
    @State static var prevIsDone: Bool = false
    
    static var previews: some View {
        DoneButton(isDone: $prevIsDone)
    }
}
