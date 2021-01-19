//
//  CircleImage.swift
//  GymNote
//
//  Created by Rafał Swat on 13/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import SwiftUI

struct RectangularImage: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var image: Image
    
    var body: some View {
        
        image
            .resizable()
            .scaledToFit()
            .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
            .frame(width: UIScreen.main.bounds.width/2.5, height: UIScreen.main.bounds.width/2.5, alignment: .center)
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(colorScheme == .light ? Color.white : Color.black, lineWidth: 4))
            .shadow(color: colorScheme == .light ? Color.magnesium : Color.customDark, radius: 5)
        
        
    }
}

struct CircleImage_Previews: PreviewProvider {

    static var previews: some View {
        RectangularImage(image: Image("ststicImage"))
    }
}

