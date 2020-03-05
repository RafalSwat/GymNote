//
//  ExitButton.swift
//  GymNote
//
//  Created by Rafał Swat on 05/03/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ExitButton: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.presentationMode) var presentationMode
    @Binding var donePresenting: Bool
    
    var exitsButtonImage: Image = Image(systemName: "multiply.circle")

    var body: some View {
    
        Button(action: {
            self.donePresenting = false
        }) {
            self.exitsButtonImage
                .font(.largeTitle)
                .foregroundColor(colorScheme == .light ? .black : .secondary)
        }
    }
}

struct ExitButton_Previews: PreviewProvider {
    
    @State static var prevDonePresenting = true
    
    static var previews: some View {
        ExitButton(donePresenting: $prevDonePresenting)
    }
}
