//
//  EditModeButton.swift
//  GymNote
//
//  Created by Rafał Swat on 06/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct EditModeButton: View {
    
    @Binding var editMode: Bool
    
    var editAction: () -> Void
    
    var body: some View {
        Button(action: {
            if self.editMode {
                self.editAction()
                
                self.editMode = false
                
            } else {
                self.editMode = true
            }
            
        }) {
            Text(self.editMode == true ? "Done" : "Edit")
        }
    }
}

struct EditModeButton_Previews: PreviewProvider {
    
    @State static var prevEditMode = true
    
    static var previews: some View {
        EditModeButton(editMode: $prevEditMode, editAction: {print("Edit Action")})
    }
}
