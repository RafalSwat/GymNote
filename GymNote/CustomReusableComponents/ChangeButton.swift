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
    
    var changesButtonImage: Image = Image(systemName: "arrow.right.arrow.left.circle.fill")

    var body: some View {
        
        Button(action: {
            print("change button tapped!")
        }) {
            self.changesButtonImage
                .font(.largeTitle)
                .foregroundColor(colorScheme == .light ? .black : .secondary)
        }
    }
}

struct ChangeButton_Previews: PreviewProvider {
    static var previews: some View {
        ChangeButton()
    }
}
