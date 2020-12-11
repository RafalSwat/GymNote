//
//  ChartValueDot.swift
//  GymNote
//
//  Created by Rafał Swat on 10/12/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ChartValueDot: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        Circle()
            .fill(Color(colorScheme == .light ? UIColor.black : UIColor.white))
            .shadow(color: .customShadow, radius: 2)
            .frame(width: 5, height: 5)
    }
}

struct ChartValueDot_Previews: PreviewProvider {
    static var previews: some View {
        ChartValueDot()
    }
}
