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
        
        VStack(alignment: .leading, spacing: 20) {
            
            HStack {

                if self.mode?.wrappedValue == .active {
                    Button(action: {
                        self.draftProfile = self.session.userSession?.userProfile ?? UserProfile()
                        self.mode?.animation().wrappedValue = .inactive
                    }) {
                        Text("Cancel")
                    }
                }
                
                Spacer()

                Button(action: {
                    if self.mode?.wrappedValue == .inactive {
                        self.mode?.animation().wrappedValue = .active
                    } else {
                        DispatchQueue.main.async {
                            self.session.updateProfileOnFBR(user: self.draftProfile)
                        }
                        self.mode?.wrappedValue = .inactive
                    }
                }) {
                    Text(self.mode?.animation().wrappedValue == .active ? "Done" : "Edit")
                }
            }
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
        
    }
}

struct ProfileHost_Previews: PreviewProvider {
    
    @State static var prevSession = FireBaseSession()
    
    static var previews: some View {
        ProfileHost().environmentObject(prevSession)
    }
}

