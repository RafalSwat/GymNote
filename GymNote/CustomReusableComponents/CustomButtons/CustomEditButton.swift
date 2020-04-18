//
//  CustomEditButton.swift
//  GymNote
//
//  Created by Rafał Swat on 11/01/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct CustomEditButton: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Binding var editMode: Bool
    var editsButtonImage: Image = Image(systemName: "pencil.circle")
    var action: () -> Void = {}
    
    var body: some View {
        
        Button(action: {
            self.editMode.toggle()
            self.action()
        }) {
                
                self.editsButtonImage
                    .font(.largeTitle)
                    .foregroundColor(colorScheme == .light ? .black : .secondary)
        }
        
    }
}

struct CustomEditButton_Previews: PreviewProvider {
    
    @State static var prevProfileEditMode = false
    
    static var previews: some View {
        CustomEditButton(editMode: $prevProfileEditMode)
    }
}
