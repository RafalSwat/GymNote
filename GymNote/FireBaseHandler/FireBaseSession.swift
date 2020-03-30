//
//  FireBaseSession.swift
//  GymNote
//
//  Created by Rafał Swat on 26/02/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//


import SwiftUI
import Firebase
import Combine

class FireBaseSession: ObservableObject {

    //MARK: Properties
    var didChange = PassthroughSubject<FireBaseSession, Never>()
    
    @Published var userSession: UserData? {
        didSet {self.didChange.send(self)}
    }
    @Published var noErrorAppearDuringAuth: Bool = false {
        didSet {self.didChange.send(self)}
    }
    @Published var usersDBRef = Database.database().reference().child("Users")
    
    var handle: AuthStateDidChangeListenerHandle?
    
    //MARK: Functions
    func listen() {
        self.handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.setupSession(userEmail: user.email!, userID: user.uid)
            } else {
                self.userSession = nil
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
            self.userSession = nil
            return true
        } catch {
            return false
        }
    }
    
    
    func setupSession(userEmail: String, userID: String) {
        
        self.usersDBRef.child(userID).child("Profile").observeSingleEvent(of: .value) { (snapshot) in

            if snapshot.exists() {
                // User is already on FirebaseDatabase, so we setup session based on it (old user)
                if let value = snapshot.value as? [String: Any] {
                    let strDate = value["dateOfBirth"] as! String
                    let convertDate = DateConverter().convertFromString(dateString: strDate)
                    let profile = UserProfile(uID: userID,
                                                  email: userEmail,
                                                  name: value["name"] as! String,
                                                  surname: value["surname"] as! String,
                                                  gender: value["gender"] as! String,
                                                  profileImage: Image("staticImage"),
                                                  height: value["height"] as! Int,
                                                  userDateOfBirth: convertDate)
                    
                    self.userSession = UserData(profile: profile)
                } 
            } else {
                // User has no data on FirebaseDatabase, so we set up default on (new user)
                let profile = UserProfile(uID: userID,
                                           email: userEmail,
                                           name: "",
                                           surname: "",
                                           gender: "non",
                                           profileImage: Image("staticImage"),
                                           height: 175,
                                           userDateOfBirth: Date())
                self.userSession = UserData(profile: profile)
                
                if let newUser = self.userSession?.userProfile {
                    
                    self.addUserToBase(user: newUser)
                }
            }
        }
    }
    
    func addUserToBase(user: UserProfile) {
        usersDBRef.child(user.userID).child("Profile").setValue(
            ["userID" : user.userID,
             "email": user.userEmail,
             "name" : user.userName,
             "surname" : user.userSurname,
             "dateOfBirth" : DateConverter.dateFormat.string(from: user.userDateOfBirth),
             "gender" : user.userGender,
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

