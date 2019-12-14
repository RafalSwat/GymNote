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
    
    public func makeBody(configuration: RectangularButtonStyle.Configuration) -> some View {
        
        configuration.label
            .frame(minWidth: CGFloat(0), maxWidth: .infinity)
            .foregroundColor(.white)
            .padding(10)
            .background(LinearGradient(gradient: Gradient(colors: [fromColor, toColor]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(15)
            .compositingGroup()
            .shadow(color: Color(UIColor.darkGray), radius: 10)
            .opacity(configuration.isPressed ? 0.5 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)

    }
}

