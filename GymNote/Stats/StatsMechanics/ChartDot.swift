//
//  ChartDot.swift
//  GymNote
//
//  Created by Rafał Swat on 13/08/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ChartDot: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        ZStack{
            Circle()
                .fill(Color(colorScheme == .light ? UIColor.white : UIColor.black))
            Circle()
                .stroke(Color(colorScheme == .light ? UIColor.black : UIColor.white), style: StrokeStyle(lineWidth: 2))
        }
        .frame(width: 6, height: 6)
        .shadow(color: Color.secondary, radius: 6, x: 0, y: 6)
    }
}

struct ChartDot_Previews: PreviewProvider {
    static var previews: some View {
        ChartDot()
    }
}
