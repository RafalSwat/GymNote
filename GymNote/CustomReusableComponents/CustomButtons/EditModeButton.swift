//
//  EditModeButton.swift
//  GymNote
//
//  Created by Rafał Swat on 06/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct EditModeButton: View {
    
    @Environment(\.editMode) var mode
    var editAction: () -> Void
    
    var body: some View {
        Button(action: {
            if self.mode?.wrappedValue == .inactive {
                self.mode?.wrappedValue = .active
            } else {
                self.editAction()
                self.mode?.wrappedValue = .inactive
            }
            
        }) {
            Text(self.mode?.wrappedValue == .active ? "Done" : "Edit")
        }
    }
}

struct EditModeButton_Previews: PreviewProvider {
    static var previews: some View {
        EditModeButton(editAction: {print("Edit Action")})
    }
}
