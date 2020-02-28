//
//  BackButton.swift
//  GymNote
//
//  Created by Rafał Swat on 20/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import SwiftUI

struct BackButton: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.presentationMode) var presentationMode
    
    var profilesButtonImage: Image = Image(systemName: "arrowshape.turn.up.left.circle")

    var body: some View {
    
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            self.profilesButtonImage
                .font(.largeTitle)
                .foregroundColor(colorScheme == .light ? .black : .secondary)
        }
    }
    
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        BackButton()
    }
}
