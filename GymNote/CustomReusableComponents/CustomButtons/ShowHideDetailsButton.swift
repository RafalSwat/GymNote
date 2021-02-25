//
//  UseButton.swift
//  GymNote
//
//  Created by Rafał Swat on 17/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ShowHideDetailsButton: View {
    
    @Binding var showHideShwitcher: Bool
    var  useAction: () -> Void

    var body: some View {
        Button(action: {
            withAnimation(.default) {
                self.useAction()
            }
        }) {
            VStack {
                if showHideShwitcher {
                    Image(systemName: "eye.slash")
                        .foregroundColor(.orange)
                        .font(.title)
                    
                    
                } else {
                    Image(systemName: "eye")
                        .foregroundColor(.orange)
                        .font(.title)
                    
                    
                }
            }
        }
    }
}

struct UseButton_Previews: PreviewProvider {
    
    @State static var showHide = false
    
    static var previews: some View {
        ShowHideDetailsButton(showHideShwitcher: $showHide, useAction: {print("Use action!")})
    }
}
