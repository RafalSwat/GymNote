//
//  ChaveronDeleteComplexButtons.swift
//  GymNote
//
//  Created by Rafał Swat on 04/03/2021.
//  Copyright © 2021 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ChaveronDeleteComplexButtons: View {
    
    @State var showButtons = false
    var deleteAction: () -> Void
    
    var body: some View {
        HStack {
        Button(action: {
            withAnimation(.default, {
                self.showButtons.toggle()
            })
            
        }) {
            if showButtons {
                Image(systemName: "chevron.right")
                    .font(.title)
                    .shadow(color: .black, radius: 2, x: -1, y: 1)
            } else {
                Image(systemName: "chevron.left")
                    .font(.title)
                    .shadow(color: .black, radius: 2, x: -1, y: 1)
            }
        }
        if self.showButtons {
            DeleteButton(deleteAction: {
                self.deleteAction()
            })
            .opacity(showButtons ? 1 : 0).animation(.default)
            .buttonStyle(BorderlessButtonStyle())
            .shadow(color: Color.customShadow, radius: 2)
            .padding(.leading, 5)
        }
    }
    }
}

