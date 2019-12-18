//
//  CircleImage.swift
//  GymNote
//
//  Created by Rafał Swat on 13/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var image: Image
    
    var body: some View {
        
        image
            .clipShape(Circle())
            .overlay(Circle().stroke(colorScheme == .light ? Color.white : Color.black, lineWidth: 4))
            .shadow(color: .gray, radius: 5)
        
    }
}

struct CircleImage_Previews: PreviewProvider {

    static var previews: some View {
        CircleImage(image: Image("ststicImage"))
    }
}

