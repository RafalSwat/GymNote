//
//  CancelEditButton.swift
//  GymNote
//
//  Created by Rafał Swat on 05/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct CancelEditModeButton: View {
    
    @Binding var editMode: Bool
    var cancelAction: () -> Void
    
    var body: some View {
        HStack {
            if self.editMode {
                Button(action: {
                    self.cancelAction()
                    self.editMode = false
                }) {
                    Text("Cancel")
                }
            }
        }
    }
}

struct CancelEditButton_Previews: PreviewProvider {
    
    @State static var prevEditMode = true
    
    static var previews: some View {
        CancelEditModeButton(editMode: $prevEditMode, cancelAction: {print("Cancel Action!")})
    }
}
