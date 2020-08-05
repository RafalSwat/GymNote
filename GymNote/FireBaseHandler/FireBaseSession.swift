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
    @Published var usersDBRef = Database.database().reference()
    @Published var usersDBStorage = Storage.storage().reference()
    
    //-------------------- Error properties handler ----------------------------
    
    @Published var errorAppearDuringAuth: Bool = true {
        didSet {self.didChange.send(self)}
    }
    @Published var errorAppearDuringImageTransfer: Bool = true {
        didSet {self.didChange.send(self)}
    }
    @Published var errorDiscription: String? {
        didSet {self.didChange.send(self)}
    }
    
    var handle: AuthStateDidChangeListenerHandle?
    
    //MARK: Setup user data
    func listen() {
        self.handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.setupSession(userEmail: user.email!, userID: user.uid)
            } else {
                self.userSession = nil
            }
        }
    }
    //MARK: Signup method
    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) {
            (user, error) in
            
            if error != nil {
                self.errorAppearDuringAuth = true
            } else {
                self.errorAppearDuringAuth = false
            }
            if user != nil {
                print("Got a new user: \(email)")
            } else {
                if let specificError = error?.localizedDescription {
                    print(specificError)
                    self.errorDiscription = specificError
                } else {
                    print("Error:  can`t register!")
                    self.errorDiscription = "Error:  can`t register!"
                }
            }
        }
    }
    //MARK: Signin method
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {
            (user, error) in
            
            if error != nil {
                self.errorAppearDuringAuth = true
            } else {
                self.errorAppearDuringAuth = false
            }
            if user != nil {
                print("Welcome back: \(email)")
            } else {
                if let specificError = error?.localizedDescription {
                    print(specificError)
                    self.errorDiscription = specificError
                } else {
                    print("Error:  can`t login!")
                    self.errorDiscription = "Error:  can`t login!"
                }
            }
        }
    }
    //MARK: Autologin method
    func tryAutoSignIn() -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        } else {
            return false
        }
    }
    //MARK: Log out method
    func signOut () -> Bool {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            return false
        } catch {
            return true
        }
    }
    
    //MARK: Setup session method
    func setupSession(userEmail: String, userID: String) {
        self.usersDBRef.child("Users").child(userID).child("Profile").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                // User is already on FirebaseDatabase, so we setup session based on it (old user)
                if let value = snapshot.value as? [String: Any] {
                    let strDate = value["dateOfBirth"] as! String
                    let convertDate = DateConverter().convertFromString(dateString: strDate)
                    
                    self.downloadImageFromDB(id: userID, completion: { downloadedImage in
                        
                        let userProfile = UserProfile(uID: userID,
                                                      email: userEmail,
                                                      name: value["name"] as! String,
                                                      surname: value["surname"] as! String,
                                                      gender: value["gender"] as! String,
                                                      profileImage: downloadedImage,
                                                      height: value["height"] as! Int,
                                                      userDateOfBirth: convertDate)
                        self.userSession = UserData(profile: userProfile)
                        self.downloadTrainingsFromDB(userID: userID)
                    })
                } 
            } else {
                // User has no data on FirebaseDatabase, so we set up default on (new user)
                let userProfile = UserProfile(uID: userID,
                                              email: userEmail,
                                              name: "",
                                              surname: "",
                                              gender: "non",
                                              profileImage: UIImage(named: "staticImage")!,
                                              height: 175,
                                              userDateOfBirth: Date())
                self.userSession = UserData(profile: userProfile)
                
                if let newUser = self.userSession?.userProfile {
                    self.uploadUserToDB(user: newUser)
                }
            }
        }
    }
    //MARK: Adding new user to data base
    func uploadUserToDB(user: UserProfile) {
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
        uploadImageToDB(uiimage: user.userImage, id: user.userID)
    }
    //MARK: Update profile for current user on DB
    func updateProfileOnDB(user: UserProfile) {
        usersDBRef.child("Users").child(user.userID).child("Profile").updateChildValues(
            ["name" : user.userName,
             "surname" : user.userSurname,
             "dateOfBirth" : DateConverter.dateFormat.string(from: user.userDateOfBirth),
             "gender" : user.userGender,
             "height" : user.userHeight])
        uploadImageToDB(uiimage: user.userImage, id: user.userID)
    }
    //MARK: Upload image to DB ( is used inside updating profile method)
    func uploadImageToDB(uiimage: UIImage, id: String) {
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
    //MARK: Download Image form DB
    func downloadImageFromDB(id: String, completion: @escaping (UIImage)->()){
        usersDBStorage.child("Images").child(id).getData(maxSize: 10*1024*1024) { (imageData, error) in
            if let err = error {
                self.errorAppearDuringImageTransfer = true
                self.errorDiscription = "Could`t get image data from FireBase DataBase!: \(err.localizedDescription)"
                print("Could`t get image data from FireBase DataBase!: \(err.localizedDescription)")
            } else {
                if let image = imageData {
                    completion(UIImage(data: image)!)
                } else {
                    self.errorAppearDuringImageTransfer = true
                    self.errorDiscription = "Error: Could`t unwrap image-data to an image!"
                    print("Error: Could`t unwrap image-data to an image!")
                }
            }
        }
    }
    
    //not sure if there is any need to this function
    func unbind () {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    //MARK: Save training in the database
    func uploadTrainingToDB(userID: String, training: Training) {
        
        // Upload training under current user
        self.usersDBRef.child("UsersTrainings").child(userID).child(training.trainingID).setValue(training.trainingName)
        
        // Upload basic info about training (no sepcific membership)
        self.usersDBRef.child("Trainings").child(training.trainingID).setValue(
            ["name" : training.trainingName,
             "description" : training.trainingDescription,
             "initialDate" : training.initialDate]
        )
        for exercise in training.listOfExercises {
            
            // Upload list of exercises under current training
            self.usersDBRef.child("ExerciseList").child(training.trainingID).child(exercise.exerciseID).setValue([
                "name" : exercise.exerciseName,
                "numberOfSeries" : exercise.exerciseNumberOfSeries])
            
            // Upload exercies series info under current date
            self.usersDBRef.child("UsersExercises").child(userID).child(exercise.exerciseID).setValue(exercise.exerciseName)
        }
        
    }
    
    //MARK: Update training under current user
    func updateUsersTrainingsToOnDB(id: String, training: Training) {
        self.usersDBRef.child("UsersTrainings").child(id).updateChildValues(
            [training.trainingID : training.trainingName])
    }
    //MARK: Update basic info about training (no sepcific membership)
    func updateTrainingOnDB(training: Training) {
        self.usersDBRef.child("Trainings").child(training.trainingID).updateChildValues(
            ["name" : training.trainingName,
             "description" : training.trainingDescription,
             "initialDate" : training.initialDate]
        )
    }
    //MARK: Update list of exercises under current training
    func updateTrainingsExerciseListOnDB(training: Training) {
        for exercise in training.listOfExercises {
            self.usersDBRef.child("ExerciseList").child(training.trainingID).child(exercise.exerciseID).updateChildValues([
                "name" : exercise.exerciseName,
                "numberOfSeries" : exercise.exerciseNumberOfSeries])
        }
    }
    //MARK: Download list of trainings, and store this data in enviroment
    func downloadTrainingsFromDB(userID: String) {
        
        var ids = [String]()
        var names = [String]()
        var descriptions = [String]()
        var dates = [String]()
        var allExercises = [[Exercise]]()
        var index = 0
        
        self.usersDBRef.child("UsersTrainings").child(userID).observeSingleEvent(of: .value) { (userSnapshot) in
            if userSnapshot.exists() {
                if let snapChildren = userSnapshot.children.allObjects as? [DataSnapshot] {
                    for trainingID in snapChildren {
                        self.usersDBRef.child("Trainings").child(trainingID.key).observeSingleEvent(of: .value) { (trainingSnapshot) in
                            if let trainingInfo = trainingSnapshot.value as? [String : Any] {
                                let name = trainingInfo["name"] as! String
                                let description = trainingInfo["description"] as! String
                                let date = trainingInfo["initialDate"] as! String
                                
                                ids.append(trainingID.key)
                                names.append(name)
                                descriptions.append(description)
                                dates.append(date)
                            }
                        }
                        self.usersDBRef.child("ExerciseList").child(trainingID.key).observeSingleEvent(of: .value) { (exerciseSnapshot) in
                            var exercises = [Exercise]()
                            for child in exerciseSnapshot.children {
                                let exerciseInfo = child  as! DataSnapshot
                                let dict = exerciseInfo.value as! [String : Any]
                                let exercise = Exercise(id: exerciseInfo.key as String,
                                                        name: dict["name"] as! String,
                                                        numberOfSeries: dict["numberOfSeries"] as! Int)
                                exercises.append(exercise)
                            }
                            allExercises.append(exercises)
                            let training = Training(id: ids[index],
                                                    name: names[index], // FIXME: index out of range
                                                    description: descriptions[index],
                                                    date: dates[index],
                                                    exercises: allExercises[index])
                            self.userSession?.userTrainings.append(training)
                            index += 1
                        }
                    }
                }
            }
        }
    }
    
    func deleteTrainingFromDB(userID: String, training: Training) {
        self.usersDBRef.child("Trainings").child(training.trainingID).removeValue()
        self.usersDBRef.child("UserTrainings").child(userID).child(training.trainingID).removeValue()
        self.usersDBRef.child("ExerciseList").child(training.trainingID).removeValue()
    }
}
