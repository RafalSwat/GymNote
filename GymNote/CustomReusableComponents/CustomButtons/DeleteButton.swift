//
//  DeleteButton.swift
//  GymNote
//
//  Created by Rafał Swat on 17/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct DeleteButton: View {
    
    var  deleteAction: () -> Void

    var body: some View {
        Button(action: {
            withAnimation(.default) {
                self.deleteAction()
            }
        }) {
            VStack {
                Image(systemName: "trash")
                    .font(.title)
                    .foregroundColor(.red)
                    
            }
            .frame(width: UIScreen.main.bounds.width/7, height: UIScreen.main.bounds.width/7, alignment: .center)
        }
    }
}

struct DeleteButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteButton(deleteAction: {print("Delete Action!")})
    }
}
