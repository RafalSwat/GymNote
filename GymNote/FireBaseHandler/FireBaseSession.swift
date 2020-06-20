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
    
    @Published var usersDBRef = Database.database().reference()
    @Published var usersDBStorage = Storage.storage().reference()
    
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
    
    func tryAutoSignIn() -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        } else {
            return false
        }
    }
    
    func signOut () -> Bool {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            return false
        } catch {
            return true
        }
    }
    
    
    func setupSession(userEmail: String, userID: String) {
        
        self.usersDBRef.child("Users").child(userID).child("Profile").observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.exists() {
                // User is already on FirebaseDatabase, so we setup session based on it (old user)
                if let value = snapshot.value as? [String: Any] {
                    let strDate = value["dateOfBirth"] as! String
                    let convertDate = DateConverter().convertFromString(dateString: strDate)
                    let userProfile = UserProfile(uID: userID,
                                              email: userEmail,
                                              name: value["name"] as! String,
                                              surname: value["surname"] as! String,
                                              gender: value["gender"] as! String,
                                              profileImage: Image("staticImage"),
                                              height: value["height"] as! Int,
                                              userDateOfBirth: convertDate)
                    
                    // #notpretty: i can use loaded trainings only inside a completion handler, so i setup all
                    // UserData at once...
                    self.uploadTrainings(userID: userID, completion: { uploadedTrainings in
                        let userTrainings = UserTrainings(id: userID, trainings: uploadedTrainings)
                        self.userSession = UserData(profile: userProfile, trainings: userTrainings)
                    })
                    
                    
                } 
            } else {
                // User has no data on FirebaseDatabase, so we set up default on (new user)
                let userProfile = UserProfile(uID: userID,
                                          email: userEmail,
                                          name: "",
                                          surname: "",
                                          gender: "non",
                                          profileImage: Image("staticImage"),
                                          height: 175,
                                          userDateOfBirth: Date())
                
                let userTrainings = UserTrainings(id: userID, trainings: [Training]())
                
                self.userSession = UserData(profile: userProfile, trainings: userTrainings)
                
                if let newUser = self.userSession?.userProfile {
                    
                    self.addUserToBase(user: newUser)
                }
            }
        }
    }
    
    func addUserToBase(user: UserProfile) {
        usersDBRef.child("Users").child(user.userID).child("Profile").setValue(
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
        usersDBRef.child("Users").child(user.userID).child("Profile").updateChildValues(
            ["name" : user.userName,
             "surname" : user.userSurname,
             "dateOfBirth" : DateConverter.dateFormat.string(from: user.userDateOfBirth),
             "gender" : user.userGender,
             "height" : user.userHeight])
    }
    
    func saveImageOnFBR(uiimage: UIImage, id: String) {
        
        if let imageToSave = uiimage.jpegData(compressionQuality: 1) {
            self.usersDBStorage.child("Images").child(id).putData(imageToSave, metadata: nil) { (_, error) in
                if let err = error {
                    print("Could`t save image in FireBase Database: \(err.localizedDescription)")
                } else {
                    print("Image was save in FiraBase DataBase successfully!")
                }
            }
        } else {
            print("Could`t case/unwrap image to data!")
        }
    }
    
    //not sure if there is any need to this function
    func unbind () {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
}

extension FireBaseSession {
    
    func addTrainingToFBR(userTrainings: UserTrainings, training: Training) {
        self.usersDBRef.child("Trainings").child(userTrainings.userID).child(training.trainingID).setValue(
            ["name" : training.trainingName,
             "subscription" : training.trainingSubscription,
             "date" : training.initialDate])
        
        for exercise in training.listOfExercises {
            self.usersDBRef.child("Trainings").child(userTrainings.userID).child(training.trainingID).child("Exercises").child(exercise.exerciseName).setValue(
                ["Series" : exercise.exerciseNumberOfSerises])
        }
    }
    
    // Can`t return [Training] in a closure, i use @escaping
    func uploadTrainings(userID: String, completion: @escaping ([Training])->()) {
        
        // Properties for storing temporary data during read process of database,
        // it will be use as a whole to setup "userTrainings/listOfTrainings"
        var tempListOfTrainings = [Training]()
        var tempTrainingsIDs = [String]()
        var tempTrainingNames = [String]()
        var tempTrainingSubscriptions = [String]()
        var tempTrainingDates = [String]()
        var tempExercisesForEachTraining = [[Exercise]]()
        
        // DataBase read proces node-by-node, assigning values to needed temporary properties
        self.usersDBRef.child("Trainings").child(userID).observe(.value) { (userSnapshot) in
            
            if userSnapshot.exists() {
                
                if let trainingsData = userSnapshot.children.allObjects as? [DataSnapshot] {
                    
                    if !trainingsData.isEmpty {
                        
                        for training in trainingsData {
                            
                            if let trainingDetails = training.value as? [String : AnyObject] {
                                
                                tempTrainingsIDs.append(training.key)
                                tempTrainingNames.append(trainingDetails["name"] as! String)
                                tempTrainingSubscriptions.append(trainingDetails["subscription"] as! String)
                                tempTrainingDates.append(trainingDetails["date"] as! String)
                                
                                if let exercises = trainingDetails["Exercises"] as? Dictionary<String, Any> {
                                    
                                    var tempExercises = [Exercise]()
                                    
                                    for exercise in exercises {
                                        
                                        let tempExercise = Exercise(name: exercise.key)
                                        
                                        if let series = exercise.value as? Dictionary<String, Any> {
                                            tempExercise.exerciseNumberOfSerises = series["Series"] as! Int
                                        }
                                        tempExercises.append(tempExercise)
                                    }
                                    tempExercisesForEachTraining.append(tempExercises)
                                }
                            }
                        }
                        // Settingup listOfTrainings using temporary properties
                        for index in 0..<userSnapshot.childrenCount {
                            let tempTraining = Training(id: tempTrainingsIDs[Int(index)],
                                                        name: tempTrainingNames[Int(index)],
                                                        subscription: tempTrainingSubscriptions[Int(index)],
                                                        date: tempTrainingDates[Int(index)],
                                                        exercises: tempExercisesForEachTraining[Int(index)])
                            tempListOfTrainings.append(tempTraining)
                        }
                        completion(tempListOfTrainings)
                    }
                }
            }
        }
        
    }
    
    func deleteTrainingFromFBR(userTrainings: UserTrainings, training: Training) {
        self.usersDBRef.child("Trainings").child(userTrainings.userID).child(training.trainingID).removeValue()
    }
}
