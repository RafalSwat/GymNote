//
//  DateBelt.swift
//  GymNote
//
//  Created by Rafał Swat on 01/03/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct DateBelt: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var lightBeltColors: [Color] = [.white, .yellow, .red]
    var darkBeltColors: [Color] = [.black, .orange, .red]
    let dataString = DateConverter.dateFormat.string(from: Date())
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(
                        colors: colorScheme == .light ? lightBeltColors : darkBeltColors),
                    startPoint: .leading, endPoint: .trailing))
                .frame(width: UIScreen.main.bounds.width, height: 35, alignment: .trailing)
                .overlay(Text(dataString).padding(), alignment: .trailing)
        }
    }
}

struct DateBelt_Previews: PreviewProvider {
    static var previews: some View {
        DateBelt()
    }
}
