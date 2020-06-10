//
//  NoteHost.swift
//  GymNote
//
//  Created by Rafał Swat on 08/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct NoteHost: View {
    
    @State var editMode = false
    @EnvironmentObject var session: FireBaseSession
    @State var draftListOfTrainings = [Training]()
    
    var body: some View {
        NavigationView {
            VStack {
                if !self.editMode {
                    NoteView(listOfTrainings: session.userSession?.userTrainings.listOfTrainings ?? [Training]())
                 } else {
                    EditNoteView()
                    
                }
            }.navigationBarItems(leading: CancelEditModeButton(editMode: $editMode, cancelAction: {
                print("Cancel Action")
            }), trailing: EditModeButton(editMode: $editMode, editAction: {
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
