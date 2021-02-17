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
            sleep(3)
            if let isAnonymous = self.session.userSession?.userProfile.isUserAnonymous {
                if isAnonymous {
                    removeUserWithData(completion: { userHasBeenDeleted in
                        if userHasBeenDeleted {
                            self.signIn = self.session.signOut()
                        }
                    })
                } else {
                    self.signIn = self.session.signOut()
                }
            }
            
        }) {
            Text("SignOut")
        }
    }
    
    func removeUserWithData(completion: @escaping (Bool)->()) {
        if let userID = self.session.userSession?.userProfile.userID {
            
            self.session.deleteImagefromFirebase(id: userID) { (errorDuringDeleteImage) in
                if !errorDuringDeleteImage {
                    self.session.deleteUserDataFromDB(userID: userID)
                    self.session.deleteUser()
                    completion(true)
                } else {
                    completion(false)
                }
                
            }
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
