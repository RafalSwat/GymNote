//
//  Indicator.swift
//  GymNote
//
//  Created by Rafał Swat on 11/08/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct Indicator: View {
    
    @State var animate = false
    
    var body: some View {
        VStack{
            VStack{
                Circle()
                    .trim(from: 0, to: 0.8)
                    .stroke(AngularGradient(gradient: .init(colors: [.orange, .red]), center: .center), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 50, height: 50)
                    .rotationEffect(.init(degrees: self.animate ? 360 : 0))
                    .animation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false))
            }
        }.onAppear {
            self.animate.toggle()
        }
    }
}

struct Indicator_Previews: PreviewProvider {
    static var previews: some View {
        Indicator()
    }
}
