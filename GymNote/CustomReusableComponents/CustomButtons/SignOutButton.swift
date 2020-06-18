//
//  SignOutButton.swift
//  GymNote
//
//  Created by Rafał Swat on 06/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct SignOutButton: View {
    
    @EnvironmentObject var session: FireBaseSession
    @Binding var signIn: Bool
    
    var body: some View {
        Button(action: {
            self.signIn = self.session.signOut()
        }) {
            Text("SignOut")
        }
    }
}

struct SignOutButton_Previews: PreviewProvider {
    
    @State static var session = FireBaseSession()
    @State static var prevSignIn = true
    
    static var previews: some View {
        SignOutButton(signIn: $prevSignIn)
            .environmentObject(session)
    }
}
