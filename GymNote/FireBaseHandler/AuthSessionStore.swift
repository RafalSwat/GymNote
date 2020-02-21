//
//  AuthSessionStore.swift
//  GymNote
//
//  Created by Rafał Swat on 10/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase
import Combine

class AuthSessionStore : ObservableObject {
    
    //MARK: Properties
    var didChange = PassthroughSubject<AuthSessionStore, Never>()
    @Published var session: UserProfile? {
        didSet {
            self.didChange.send(self)
        }
    }
    @Published var noErrorAppearDuringAuth: Bool = false {
        didSet {
            self.didChange.send(self)
        }
    }
    @Published var usersDBRef = Database.database().reference().child("Users")
    
    var handle: AuthStateDidChangeListenerHandle?
    
    init() {
        self.session = .default
    }
    
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
                    name: user.displayName ?? "Anonim",
                    surname: "Non",
                    gender: "non",
                    profileImage: Image("staticImage"),
                    height: 170,
                    userDateOfBirth: Date()
                )
                if self.session != nil {
                    self.addUser(user: self.session!)
                } else {
                    print("Something dont work! --> Problem with add a new user during listen")
                }
                
                
            } else {
                // if we don't have a user, set our session to nil
                self.session = nil
            }
        }
    }
    
    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) {
            (user, error) in
            
            if error != nil {
                self.noErrorAppearDuringAuth = false
            } else {
                self.noErrorAppearDuringAuth = true
            }
            
            if user != nil {
                // show some details from user
                print("Got a new user: \(email)")
                
            } else {
                
                if let specificError = error?.localizedDescription {
                    print(specificError)
                } else {
                    print("Error:  can`t register!")
                }
            }
        }
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {
            (user, error) in
            
            if error != nil {
                self.noErrorAppearDuringAuth = false
            } else {
                self.noErrorAppearDuringAuth = true
            }
            
            if user != nil {
                // show some details from user
                print("Welcome back: \(email)")
            } else {
                if let specificError = error?.localizedDescription {
                    print(specificError)
                } else {
                    print("Error:  can`t login!")
                }
            }
        }
        
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
    
    func addUser(user: UserProfile) {
        usersDBRef.child(user.userID).child("Profile").setValue(
            ["userID" : user.userID,
             "email": user.userEmail,
             "name" : user.userName,
             "surname" : user.userSurname,
             "dateOfBirth" : DateConverter.dateFormat.string(from: user.userDateOfBirth),
             "gender" : "non",
             "height" : user.userHeight]) {
                
                (error, reference) in
                
                if error != nil {
                    if let specificError = error?.localizedDescription {
                        print(specificError)
                    } else {
                        print("Error:  can`t login!")
                    }
                }
        }
    }
    
    func updateProfileOnFBR(user: UserProfile) {
        usersDBRef.child(user.userID).child("Profile").updateChildValues(
            ["name" : user.userName,
             "surname" : user.userSurname,
             "dateOfBirth" : DateConverter.dateFormat.string(from: user.userDateOfBirth),
             "gender" : user.userGender,
             "height" : user.userHeight])
    }
    
    //not sure if there is any need to this function
    func unbind () {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
