//
//  CancelEditButton.swift
//  GymNote
//
//  Created by Rafał Swat on 05/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct CancelEditModeButton: View {
    
    @Environment(\.editMode) var mode
    var cancelAction: () -> Void
    
    var body: some View {
        HStack {
            if self.mode?.wrappedValue == .active {
                Button(action: {
                    self.cancelAction()
                    self.mode?.animation().wrappedValue = .inactive
                }) {
                    Text("Cancel")
                }
            }
        }
    }
}

struct CancelEditButton_Previews: PreviewProvider {
    static var previews: some View {
        CancelEditModeButton(cancelAction: {print("Cancel Action!")})
    }
}
