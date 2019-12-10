//
//  AuthSessionStore.swift
//  GymNote
//
//  Created by Rafał Swat on 10/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import SwiftUI
import Firebase
import Combine

class SessionStore : ObservableObject {
    
     //MARK: Properties
    var didChange = PassthroughSubject<SessionStore, Never>()
    @Published var session: UserProfile? { didSet { self.didChange.send(self) }}
    var handle: AuthStateDidChangeListenerHandle?
    
    
    //MARK: Functions
    func listen () {
        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener { (auth, newUser) in
            if let user = newUser {
                
                // if we have a user, create a new user model
                print("Got user: \(user)")
                
                self.session = UserProfile(
                    uID: user.uid,
                    email: user.email!,
                    name: user.displayName!,
                    surname: "",
                    gender: .non,
                    profileImage: UIImage(named: "staticImage")!,
                    height: 170
                )
            } else {
                // if we don't have a user, set our session to nil
                self.session = nil
            }
        }
    }

    func signUp(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
        ) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }

    func signIn(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
        ) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }

    func signOut () -> Bool {
        do {
            try Auth.auth().signOut()
            self.session = nil
            return true
        } catch {
            return false
        }
    }
}
