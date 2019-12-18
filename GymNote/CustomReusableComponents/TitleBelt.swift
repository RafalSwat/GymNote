//
//  TitleBelt.swift
//  GymNote
//
//  Created by Rafał Swat on 18/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import SwiftUI

struct TitleBelt: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var title: String = "Title"
    var subtitle: String = "subtitle"
    var image = Image("staticImage")
    var lightBeltColors: [Color] = [.white, .yellow, .red]
    var darkBeltColors: [Color] = [.black, .orange, .red]
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(
                        colors: colorScheme == .light ? lightBeltColors : darkBeltColors),
                    startPoint: .leading, endPoint: .trailing))
                .frame(width: UIScreen.main.bounds.width, height: 140, alignment: .trailing)
                .overlay(CircleImage(image: image), alignment: .leading)
            
            VStack(alignment: .center) {
                Text(title)
                    .font(.title)

                Text(subtitle)
                    .font(.subheadline)
            }.offset(x: UIScreen.main.bounds.width/4)
            
        }
    }
}

struct TitleBelt_Previews: PreviewProvider {
    
    static var previews: some View {
        TitleBelt()
    }
}
