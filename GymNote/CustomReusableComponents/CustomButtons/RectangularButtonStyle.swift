//
//  RectangularButtonStyle.swift
//  GymNote
//
//  Created by Rafał Swat on 14/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import SwiftUI

struct RectangularButtonStyle: ButtonStyle {
    var fromColor: Color = .orange
    var toColor: Color = .red
    var minWidth  = CGFloat(0)
    var maxWidth = CGFloat.infinity
    var minHeight = CGFloat(40)
    var maxHeight = CGFloat(50)
    
    public func makeBody(configuration: RectangularButtonStyle.Configuration) -> some View {
        
        configuration.label
            .frame(minWidth: minWidth, maxWidth: maxWidth, minHeight: minHeight, maxHeight: maxHeight)
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [fromColor, toColor]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(5)
            .compositingGroup()
            .shadow(color: Color.customShadow, radius: 4, x: -3, y: 3)
            .opacity(configuration.isPressed ? 0.5 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
        

    }
}


