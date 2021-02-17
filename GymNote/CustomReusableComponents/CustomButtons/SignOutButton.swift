//
//  SignOutButton.swift
//  GymNote
//
//  Created by Rafał Swat on 06/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct SignOutButton: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Profile.entity(), sortDescriptors: []) var imageCoreData: FetchedResults<Profile>
    
    @EnvironmentObject var session: FireBaseSession
    @Binding var signIn: Bool
    
    var body: some View {
        Button(action: {
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
            
            deleteImageFromCoreData(id: userID)
            
            self.session.deleteImagefromFirebase(id: userID) { _ in }            
            self.session.deleteUserDataFromDB(userID: userID) { (errorDuringDeleteUserData) in
                if !errorDuringDeleteUserData {
                    self.session.deleteUser() { (errorDuringDeleteUser) in
                        if !errorDuringDeleteUser {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    }
                } else {
                    completion(false)
                }
            }
            
        }
    }
    func deleteImageFromCoreData(id: String) {
        for image in imageCoreData {
            if image.userID == id {
                let imageObjectToDelete = image
                moc.delete(imageObjectToDelete)
            }
            do {
                try moc.save()
                print("Image photo was deleted successfully from Core Data")
            } catch {
                print("Removing Image from CoreData failed!")
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
