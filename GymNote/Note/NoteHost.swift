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
                    EditNoteView(listOfTrainings: $draftListOfTrainings)
                        .onAppear {
                            self.draftListOfTrainings = self.session.userSession?.userTrainings.listOfTrainings ?? [Training]()
                    }
                    
                }
            }.navigationBarItems(leading: CancelEditModeButton(editMode: $editMode, cancelAction: {
                self.draftListOfTrainings = self.session.userSession?.userTrainings.listOfTrainings ?? [Training]()
            }), trailing: EditModeButton(editMode: $editMode, editAction: {
                self.session.userSession?.userTrainings.listOfTrainings = self.draftListOfTrainings
                
            }))
        }
    }
}

struct NoteHost_Previews: PreviewProvider {
    
    @State static var prevSession = FireBaseSession()
    
    static var previews: some View {
        NoteHost()
            .environmentObject(prevSession)
    }
}
