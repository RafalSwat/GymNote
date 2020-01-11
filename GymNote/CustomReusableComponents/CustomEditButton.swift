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
    
    var editsButtonImage: Image = Image(systemName: "pencil.circle")

    var body: some View {
    
        Button(action: {
            print("edit button tapped!")
        }) {
            self.editsButtonImage
                .font(.largeTitle)
                .foregroundColor(colorScheme == .light ? .black : .secondary)
        }
    }
    
}

struct CustomEditButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomEditButton()
    }
}
