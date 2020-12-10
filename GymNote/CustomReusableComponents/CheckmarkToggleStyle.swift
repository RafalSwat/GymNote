//
//  CheckmarkToggleStyle.swift
//  GymNote
//
//  Created by Rafał Swat on 04/12/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct CheckmarkToggleStyle: ToggleStyle {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Rectangle()
                .fill(configuration.isOn ? LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: .leading, endPoint: .trailing) : LinearGradient(gradient: Gradient(colors: [.customLight, .customDark]), startPoint: .leading, endPoint: .trailing))
                .frame(width: 63, height: 28)
                .overlay(
                    Rectangle()
                        .foregroundColor(colorScheme == .light ? .white : .secondary)
                        .frame(width: 30)
                        .cornerRadius(5)
                        .padding(.all, 3)
                        .overlay(
                            Image(systemName: configuration.isOn ? "checkmark" : "xmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .font(Font.title.weight(.black))
                                .frame(width: 8, height: 8, alignment: .center)
                                .foregroundColor(colorScheme == .light ? .black : .white)
                        )
                        .offset(x: configuration.isOn ? 13.5 : -13.5, y: 0)
                        .animation(Animation.linear(duration: 0.2))
                        
                ).cornerRadius(7)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
    
}
