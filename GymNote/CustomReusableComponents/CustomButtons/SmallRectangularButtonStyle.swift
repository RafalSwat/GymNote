//
//  SmallRectangularButtonStyle.swift
//  GymNote
//
//  Created by Rafał Swat on 10/12/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct SmallRectangularButtonStyle: ButtonStyle {
    
    var fromColor: Color = .orange
    var toColor: Color = .red
    
    public func makeBody(configuration: SmallRectangularButtonStyle.Configuration) -> some View {
        
        configuration.label
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [fromColor, toColor]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(5)
            .shadow(color: Color.black, radius: 3, x: -2, y: 2)
            .opacity(configuration.isPressed ? 0.5 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
    }
}



