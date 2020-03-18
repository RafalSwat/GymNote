//
//  ResizableRectangularButtonStyle.swift
//  GymNote
//
//  Created by Rafał Swat on 18/03/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ResizableRectangularButtonStyle: ButtonStyle {
    var fromColor: Color = .customDark
    var toColor: Color = .green
    var minWidth  = CGFloat(0)
    var maxWidth = CGFloat.infinity
    var minHeight = CGFloat(0)
    var maxHeight = CGFloat.infinity
    
    public func makeBody(configuration: RectangularButtonStyle.Configuration) -> some View {
        
        configuration.label
            .frame(minWidth: minWidth, maxWidth: maxWidth, minHeight: minHeight, maxHeight: maxHeight)
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [fromColor, toColor]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(5)
            .compositingGroup()
            .shadow(color: Color(UIColor.darkGray), radius: 10)
            .opacity(configuration.isPressed ? 0.5 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
        
    }
}
