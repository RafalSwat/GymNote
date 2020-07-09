//
//  ProfileHost.swift
//  GymNote
//
//  Created by Rafał Swat on 30/05/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ProfileHost: View {

    @State var editMode = false
    @EnvironmentObject var session: FireBaseSession
    @State var draftProfile = UserProfile()

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {

                if !self.editMode {
                    ProfileView(profile: session.userSession?.userProfile ?? UserProfile())
                } else {
                    ProfileEditView(profile: $draftProfile)
                        .onAppear {
                            self.draftProfile = self.session.userSession?.userProfile ?? UserProfile()
                        }
                }
            }
            .navigationBarItems(
                leading: CancelEditModeButton(editMode: $editMode, cancelAction: {
                    self.draftProfile = self.session.userSession?.userProfile ?? UserProfile()
                }),
                trailing: EditModeButton(editMode: $editMode, editAction: {
                    self.session.userSession?.userProfile = self.draftProfile
                    self.session.updateProfileOnFBR(user: self.draftProfile)
                })
            )
        }
    }
}



struct ProfileHost_Previews: PreviewProvider {
    
    @State static var prevSession = FireBaseSession()
    
    static var previews: some View {
        ProfileHost()
            .environmentObject(prevSession)
        
    }
}



