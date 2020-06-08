//
//  ProfileHost.swift
//  GymNote
//
//  Created by Rafał Swat on 30/05/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ProfileHost: View {

    @Environment(\.editMode) var mode
    @EnvironmentObject var session: FireBaseSession
    @State var draftProfile = UserProfile()

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {

                if self.mode?.wrappedValue == .inactive {
                    ProfileView(profile: session.userSession?.userProfile ?? UserProfile())
                } else {
                    ProfileEditView(profile: $draftProfile)
                        .onAppear {
                            self.draftProfile = self.session.userSession?.userProfile ?? UserProfile()
                        }
                        .onDisappear {
                            self.session.userSession?.userProfile = self.draftProfile
                        }
                }
            }
            .navigationBarItems(
                leading: CancelEditModeButton(cancelAction: {
                    self.draftProfile = self.session.userSession?.userProfile ?? UserProfile()
                }),
                trailing: EditModeButton(editAction: {
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



