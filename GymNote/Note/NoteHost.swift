//
//  NoteHost.swift
//  GymNote
//
//  Created by Rafał Swat on 08/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct NoteHost: View {
    
    @Environment(\.editMode) var mode
    
    var body: some View {
        NavigationView {
            VStack {
                 if self.mode?.wrappedValue == .inactive {
                    NoteView()
                 } else {
                    Text("Edit Note View...")
                }
            }.navigationBarItems(leading: CancelEditModeButton(cancelAction: {
                print("Cancel Action")
            }), trailing: EditModeButton(editAction: {
                print("Edit Action")
            }))
        }
    }
}

struct NoteHost_Previews: PreviewProvider {
    static var previews: some View {
        NoteHost()
    }
}
