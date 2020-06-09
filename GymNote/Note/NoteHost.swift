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
    @EnvironmentObject var session: FireBaseSession
    
    var body: some View {
        NavigationView {
            VStack {
                if self.mode?.wrappedValue == .inactive {
                    NoteView(listOfTrainings: session.userSession?.userTrainings.listOfTrainings ?? [Training]())
                 } else {
                    EditNoteView()
                    
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
