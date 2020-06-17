//
//  UseButton.swift
//  GymNote
//
//  Created by Rafał Swat on 17/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct UseButton: View {
    
    var  useAction: () -> Void

    var body: some View {
        Button(action: {
            withAnimation(.default) {
                self.useAction()
            }
        }) {
            VStack {
                Image(systemName: "square.and.pencil")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
            }
            .frame(width: UIScreen.main.bounds.width/7, height: UIScreen.main.bounds.width/7, alignment: .center)
        }
    }
}

struct UseButton_Previews: PreviewProvider {
    static var previews: some View {
        UseButton(useAction: {print("Use action!")})
    }
}
