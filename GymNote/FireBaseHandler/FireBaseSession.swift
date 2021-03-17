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
    
    var handle: AuthStateDidChangeListenerHandle?
    
    //MARK: Setup user data
    func listen() {
        self.handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.setupSession(userID: user.uid)
            } else {
                self.userSession = nil
            }
        }
    }
    //MARK: Signup method
    
    
    
    func signInAnonymously(completion: @escaping (Bool, String?)->()) {
        Auth.auth().signInAnonymously { (authDataResult, error) in
            if let user = authDataResult?.user {
                if user.isAnonymous {
                    print("Got a new anonymous user")
                } else {
                    print("Got a new user!")
                }
                if error != nil {
                    completion(true, error?.localizedDescription)
                } else {
                    completion(false, error?.localizedDescription)
                }
            } else {
                if let specificError = error?.localizedDescription {
                    print(specificError)
                } else {
                    print("Error:  can`t register!")
                }
            }
        }
    }
    
    
    func signUp(email: String, password: String, completion: @escaping (Bool, String?)->()) {
        Auth.auth().createUser(withEmail: email, password: password) {
            (user, error) in
            
            if error != nil {
                completion(true, error?.localizedDescription)
            } else {
                completion(false, error?.localizedDescription)
            }
            if user != nil {
                print("Got a new user: \(email)")
                Auth.auth().currentUser?.sendEmailVerification(completion: { (emailVerificationError) in
                    if emailVerificationError != nil {
                        completion(true, emailVerificationError?.localizedDescription)
                    } else {
                        completion(false, "confirmation email sent to: \(email)")
                        print("confirmation email sent to: \(email)")
                    }
                })
                
            } else {
                if let specificError = error?.localizedDescription {
                    completion(true, specificError)
                    print(specificError)
                } else {
                    completion(false, "Error:  can`t register!")
                    print("Error:  can`t register!")
                }
            }
        }
    }
    func mergeAnonymousUserWithEmail(email: String, password: String, completion: @escaping (Bool, String?)->()) {
        
        if let user = Auth.auth().currentUser {
            
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            
            user.link(with: credential, completion: { (authResult, error) in
                if error != nil {
                    completion(true, error?.localizedDescription)
                } else {
                    if let mergeWithUser = authResult?.user {
                        mergeWithUser.sendEmailVerification(completion: { (emailVerificationError) in
                            if emailVerificationError != nil {
                                completion(true, emailVerificationError?.localizedDescription)
                            } else {
                                var profile = self.userSession?.userProfile
                                profile?.isUserAnonymous = false
                                profile?.userEmail = email
                                self.updateProfileOnDB(user: profile!)
                                completion(false, "confirmation email sent to: \(email)")
                                print("confirmation email sent to: \(email)")
                            }
                        })
                    }
                }
            })
        } 
    }
    
    //MARK: Signin method
    func signIn(email: String, password: String, completion: @escaping (Bool, String?)->()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                completion(true, error?.localizedDescription)
            } else if user == nil {
                //print("Cooooo dooo kuuuurwy się dzieje!!!!")
            }
            self.checkIfTheEmailIsVerified(completion: { isVerified, errorDiscription in
                if isVerified {
                    if user != nil {
                        completion(false, errorDiscription)
                        print("Welcome back: \(email)")
                    } else {
                        if let specificError = error?.localizedDescription {
                            print(specificError)
                        } else {
                            print("Error:  can`t login!")
                        }
                    }
                } else {
                    completion(true, errorDiscription)
                }
            })
        }
    }
    
    //MARK: Autologin method
    func tryAutoSignIn() -> Bool {
        if let user = Auth.auth().currentUser {
            if !user.isEmailVerified {
                if user.isAnonymous {
                    return true
                } else {
                    return false
                }
            } else {
                return true
            }
        } else {
            return false
        }
    }
    func checkIfTheEmailIsVerified(completion: @escaping (Bool, String)->()){
        if let user = Auth.auth().currentUser {
        user.reload(completion: { (error) in
            if let error = error {
                completion(false, "Error during reolad user after email verification: \(error.localizedDescription)")
            } else {
                let isEmailVerified = Auth.auth().currentUser?.isEmailVerified
                if isEmailVerified == true {
                    completion(true, "email: \(String(describing: user.email)) is verified")
                } else {
                    completion(false, "email: \(String(describing: user.email)) is not verified or there is no information on verification at all")
                }
            }
        })
        } else {
            completion(false, "Error during reolad user after email verification: Could not find the user!")
        }
    }
    func getCurrentUser() -> User? {
        let user  = Auth.auth().currentUser
        return user
    }
    
    //MARK: Log out method
    func signOut () -> Bool {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            return false
        }  catch {
            return true
        }
    }
    //MARK: Reset password method
    func restetPassword(email: String, completion: @escaping (Bool, String?)->()) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            
            if error != nil {
                completion(true, error?.localizedDescription)
            } else {
                completion(false, "Reset password email has been successfully sent!")
            }
        }
    }
    
    //MARK: Delete user data method
    
    func deleteUserDataFromDB(userID: String, completion: @escaping (Bool)->()) {
        if self.userSession != nil {
            self.downloadTrainingsFromDB(userID: userID) { (errorOccur1) in
                if errorOccur1 {
                    self.downloadUserStatisticsFromDB(userID: userID) { (errorOccur2) in
                        if errorOccur2 {
                            self.deleteAllTraingsBelongToCurrentUser(userID: userID, completion: { (errorOccur3) in
                                if !errorOccur3 {
                                    self.deleteAllStatsBelongToCurrentUser(userID: userID, completion: { (errorOccur4) in
                                        if !errorOccur4 {
                                            self.deleteCalendarDataFromDB(userID: userID, completion: { (errorOccur5) in
                                                if !errorOccur5 {
                                                    self.deleteExercisesCreatedByUser(userID: userID, completion: {(errorOccur6) in
                                                        if !errorOccur6 {
                                                            self.deleteUserProfile(userID: userID, completion: { (errorOccur7) in
                                                                if !errorOccur7 {
                                                                    completion(false)
                                                                } else {
                                                                    completion(true)
                                                                }
                                                            })
                                                        } else {
                                                            completion(true)
                                                        }
                                                    })
                                                } else {
                                                    completion(true)
                                                }
                                            })
                                        } else {
                                            completion(true)
                                        }
                                    })
                                } else {
                                    completion(true)
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    //Delete user profile
    func deleteUserProfile(userID: String, completion: @escaping (Bool)->()) {
        self.usersDBRef.child("Users").child(userID).removeValue() { error, _ in
            if let error = error  {
                print("While deleting user profile an error occurred: \(error.localizedDescription)")
                completion(true)
            } else {
                print("Data for path: [Users/...] removed successfully!")
                completion(false)
            }
        }
    }
    //Delete all trainings belong to current user
    func deleteAllTraingsBelongToCurrentUser(userID: String, completion: @escaping (Bool)->()) {
        if self.userSession!.userTrainings.isEmpty {
            completion(false)
        } else {
            var counter = 0
            let numberOfTrainings = self.userSession!.userTrainings.count
            
            for training in self.userSession!.userTrainings {
                self.deleteTrainingFromDB(userID: userID, training: training, completion: { errorOccur, errorDescription in
                                            if errorOccur {
                                                print(errorDescription ?? "Unknow error occur during removing training!")
                                                completion(true)
                                            } else {
                                                counter += 1
                                                if counter == numberOfTrainings {
                                                    completion(false)
                                                }
                                            }})
            }
        }
    }
    //Delete all stats belong to current user
    func deleteAllStatsBelongToCurrentUser(userID: String, completion: @escaping (Bool)->()) {
        if self.userSession!.userStatistics.isEmpty {
            completion(false)
        } else {
            var counter = 0
            let numberOfStats = self.userSession!.userStatistics.count
            
            for statsistic in self.userSession!.userStatistics {
                self.deleteSingleStataisticsFromDB(userID: userID, statistics: statsistic, completion: { errorOccur, errorDescription in
                                                    if errorOccur {
                                                        print(errorDescription ?? "Unknow error occur during removing training!")
                                                        completion(true)
                                                    } else {
                                                        counter += 1
                                                        if counter == numberOfStats {
                                                            completion(false)
                                                        }
                                                    }})
            }
        }
    }
    //delete all calendar data
    func deleteCalendarDataFromDB(userID: String, completion: @escaping (Bool)->()) {
        self.deleteTrainingSessionsFromDB(userID: userID) { (errorDuringDeleteTrainingSessions) in
            if errorDuringDeleteTrainingSessions {
                completion(true)
            } else {
                self.usersDBRef.child("UserNotes").child(userID).removeValue() { error, _ in
                    if error != nil {
                        print("Error during delete action on UserNotes: \(String(describing: error?.localizedDescription))")
                        completion(true)
                    } else {
                        print("Data for path: [UserNotes/...] removed successfully!")
                        completion(false)
                    }
                }
            }
        }
    }
    
    
    //Delete user from Firebase
    func deleteUser(completion: @escaping (Bool)->()) {
        //Delete user
        let user = Auth.auth().currentUser
        
        user?.delete { error in
            if let error = error {
                print("While deleting user an error occurred: \(error.localizedDescription)")
                completion(true)
            } else {
                print("User has been successfully removed from database!")
                completion(false)
                self.userSession = nil
                return
            }
        }
    }
    
    //MARK: Setup session method
    func setupSession(userID: String) {
        self.usersDBRef.child("Users").child(userID).child("Profile").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                // User is already on FirebaseDatabase, so we setup session based on it (old user)
                if let value = snapshot.value as? [String: Any] {
                    let strDate = value["dateOfBirth"] as! String
                    let strDateActualization = value["lastImageActualization"] as? String
                    let convertDate = DateConverter.convertFromString(dateString: strDate)
                    
                    let currentDate = DateConverter.fullDateFormat.string(from: Date())
                    let lastActualizationDate = DateConverter.convertFromStringFull(dateString: strDateActualization ?? currentDate)
                    
                    
                    let userProfile = UserProfile(uID: userID,
                                                  email: value["email"] as! String,
                                                  name: value["name"] as! String,
                                                  surname: value["surname"] as! String,
                                                  gender: value["gender"] as! String,
                                                  profileImage: UIImage(named: "staticImage")!,
                                                  height: value["height"] as! Int,
                                                  userDateOfBirth: convertDate,
                                                  lastImageActualization: lastActualizationDate,
                                                  isAnonymous: value["isAnonymous"] as? Bool ?? false)
                    self.userSession = UserData(profile: userProfile)
                } 
            } else {
                // User has no data on FirebaseDatabase, so we set up default on (new user)
                if let user = Auth.auth().currentUser {
                    if user.isAnonymous {
                        let userProfile = UserProfile(uID: userID,
                                                      email: "",
                                                      name: "",
                                                      surname: "",
                                                      gender: "non",
                                                      profileImage: UIImage(named: "staticImage")!,
                                                      height: 175,
                                                      userDateOfBirth: Date(),
                                                      lastImageActualization : Date(),
                                                      isAnonymous: true)
                        self.userSession = UserData(profile: userProfile)
                        
                        if let newUser = self.userSession?.userProfile {
                            self.uploadUserToDB(user: newUser, completion: {_ in }) //TODO: do sth with this completion!!! you lazy bastard
                        }
                        
                    } else {
                        let userProfile = UserProfile(uID: userID,
                                                      email: user.email ?? "",
                                                      name: "",
                                                      surname: "",
                                                      gender: "non",
                                                      profileImage: UIImage(named: "staticImage")!,
                                                      height: 175,
                                                      userDateOfBirth: Date(),
                                                      lastImageActualization : Date(),
                                                      isAnonymous: false)
                        self.userSession = UserData(profile: userProfile)
                        
                        if let newUser = self.userSession?.userProfile {
                            self.uploadUserToDB(user: newUser, completion: {_ in }) //TODO: do sth with this completion!!! you lazy bastard
                        }
                    }
                }
            }
        }
    }
    //MARK: Adding new user to data base
    func uploadUserToDB(user: UserProfile, completion: @escaping (Bool)->()) {
        let currentDate = DateConverter.fullDateFormat.string(from: Date())
        usersDBRef.child("Users").child(user.userID).child("Profile").setValue(
            ["userID" : user.userID,
             "email": user.userEmail,
             "name" : user.userName,
             "surname" : user.userSurname,
             "dateOfBirth" : DateConverter.dateFormat.string(from: user.userDateOfBirth),
             "gender" : user.userGender,
             "height" : user.userHeight,
             "lastImageActualization" : currentDate,
             "isAnonymous" : user.isUserAnonymous]) {
            
            (error, reference) in
            
            if error != nil {
                completion(true)
                if let specificError = error?.localizedDescription {
                    print(specificError)
                } else {
                    print("Error:  can`t login!")
                }
            } else {
                completion(false)
            }
        }
        uploadImageToDB(uiimage: user.userImage, id: user.userID)
    }
    
    //MARK: Update profile for current user on DB
    func updateProfileOnDB(user: UserProfile) {
        
        if let lastActualization = user.lastImageActualization {
            let dateString = DateConverter.fullDateFormat.string(from: lastActualization)
            usersDBRef.child("Users").child(user.userID).child("Profile").updateChildValues(
                ["email" : user.userEmail,
                 "name" : user.userName,
                 "surname" : user.userSurname,
                 "dateOfBirth" : DateConverter.dateFormat.string(from: user.userDateOfBirth),
                 "gender" : user.userGender,
                 "height" : user.userHeight,
                 "lastImageActualization" : dateString,
                 "isAnonymous" : user.isUserAnonymous])
            print("----> update lastImageActualization")
        } else {
            usersDBRef.child("Users").child(user.userID).child("Profile").updateChildValues(
                ["email" : user.userEmail,
                 "name" : user.userName,
                 "surname" : user.userSurname,
                 "dateOfBirth" : DateConverter.dateFormat.string(from: user.userDateOfBirth),
                 "gender" : user.userGender,
                 "height" : user.userHeight,
                 "isAnonymous" : user.isUserAnonymous])
        }
    }
    
    //MARK: Upload image to Firebase ( is used inside updating profile method)
    func uploadImageToDB(uiimage: UIImage, id: String) {
        if let imageToSave = uiimage.jpegData(compressionQuality: 0.3) {
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
    
    //MARK: Download Image form FireBase
    func downloadImageFromDB(id: String, completion: @escaping (UIImage, Bool)->()){
        usersDBStorage.child("Images").child(id).getData(maxSize: 10*1024*1024) { (imageData, error) in
            if let err = error {
                print("Could`t get image data from FireBase DataBase!: \(err.localizedDescription)")
                completion(UIImage(named: "staticImage")!, false)
            } else {
                if let image = imageData {
                    completion(UIImage(data: image)!, true)
                } else {
                    print("Error: Could`t unwrap image-data to an image!")
                }
            }
        }
    }
    func deleteImagefromFirebase(id: String, completion: @escaping (Bool)->()) {
        usersDBStorage.child("Images").child(id).delete(completion: { error in
            if let err = error {
                print("Could`t delete image from Firebase DataBase!: \(err.localizedDescription)")
                completion(true)
            } else {
                print("Image removed successfully from Firebase DataBase!")
                completion(false)
            }
        })
    }
    
    //not sure if there is any need to this function
    func unbind () {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    func uploadExerciseCreatedByUser(userID: String, exercise: Exercise, completion: @escaping (Bool, String?)->()) {
        self.usersDBRef.child("ExercisesCreatedByUsers").child(userID).child(exercise.exerciseID).setValue(exercise.exerciseName) { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data path: [ExercisesCreatedByUsers/...] could not be saved: \(error.localizedDescription)")
                completion(true, error.localizedDescription)
            } else {
                print("Data path: [ExercisesCreatedByUsers/...] saved successfully!")
                completion(false, nil)
            }
        }
    }
    func deleteExercisesCreatedByUser(userID: String, completion: @escaping (Bool)->()) {
        self.usersDBRef.child("ExercisesCreatedByUsers").child(userID).removeValue() { error, _ in
            if let error = error  {
                print("While deleting user exercises created by users an error occurred: \(error.localizedDescription)")
                completion(true)
            } else {
                print("Data for path: [ExercisesCreatedByUsers/...] removed successfully!")
                completion(false)
            }
        }
    }
    
    func downloadExerciseCreatedByUser(userID: String, completion: @escaping ([Exercise])->()) {
        
        var listOfCreatedByUserExercises = [Exercise]()
        var counter = 0
        
        self.usersDBRef.child("ExercisesCreatedByUsers").child(userID).observeSingleEvent(of: .value) { (userSnapshot) in
            if userSnapshot.exists() {
                if let snapChildren = userSnapshot.children.allObjects as? [DataSnapshot] {
                    for exercise in snapChildren {
                        let usersExercise = Exercise(id: exercise.key,
                                                     name: exercise.value as! String,
                                                     createdByUser: true)
                        listOfCreatedByUserExercises.append(usersExercise)
                        counter += 1
                    }
                    if counter == snapChildren.count {
                        completion(listOfCreatedByUserExercises)
                    }
                }
            } else {
                completion([Exercise]())
            }
        }
    }
    
    
    //MARK: Save training in the database
    func uploadTrainingToDB(userID: String, training: Training, completion: @escaping (Bool, String?)->()) {
        
        // Upload training under current user
        self.usersDBRef.child("UsersTrainings").child(userID).child(training.trainingID).setValue(1) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data path: [UserTrainings/...] could not be saved: \(error.localizedDescription).")
                completion(true, error.localizedDescription)
            } else {
                print("Data path: [UserTrainings/...] saved successfully!")
                completion(false, nil)
            }
        }
        
        // Upload basic info about training (no sepcific membership)
        self.usersDBRef.child("Trainings").child(training.trainingID).setValue(
            ["name" : training.trainingName,
             "description" : training.trainingDescription,
             "initialDate" : training.initialDate,
             "isTrainingActive" : training.isTrainingActive]) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data path: [Trainings/...] could not be saved: \(error.localizedDescription).")
                //errorDescription = error.localizedDescription
                completion(true, error.localizedDescription)
            } else {
                print("Data path: [Trainings/...] saved successfully!")
                //errorTrainings = false
                completion(false, nil)
            }
        }
        for trainingComponent in training.listOfExercises {
            
            // Upload list of exercises under current training
            self.usersDBRef.child("ExerciseList").child(training.trainingID).child(trainingComponent.exercise.exerciseID).setValue([
                        "name" : trainingComponent.exercise.exerciseName,
                        "createdByUser" : trainingComponent.exercise.exerciseCreatedByUser,
                        "numberOfSeries" : trainingComponent.exerciseNumberOfSeries,
                        "order" : trainingComponent.exerciseOrderInList]) {
                
                (error:Error?, ref:DatabaseReference) in
                if let error = error {
                    print("Data path: [ExerciseList/\(training.trainingID)/...] could not be saved: \(error.localizedDescription).")
                    //errorDescription = error.localizedDescription
                    completion(true, error.localizedDescription)
                } else {
                    print("Data path: [ExerciseList/\(training.trainingID)/...] saved successfully!")
                    //errorExerciseList = false
                    completion(false, nil)
                }
            }
            
        }
    }
    //MARK: Update training under current user
    func updateUsersTrainingsToOnDB(id: String, training: Training) {
        self.usersDBRef.child("UsersTrainings").child(id).updateChildValues(
            [training.trainingID : training.trainingName])
    }
    //MARK: Update basic info about training (no sepcific membership)
    func updateTrainingOnDBs(training: Training) {
        self.usersDBRef.child("Trainings").child(training.trainingID).updateChildValues(
            ["name" : training.trainingName,
             "description" : training.trainingDescription,
             "initialDate" : training.initialDate,
             "isTrainingActive" : training.isTrainingActive]
        )
    }
    //MARK: Update list of exercises under current training
    func updateTrainingsExerciseListOnDB(training: Training) {
        for trainingComponent in training.listOfExercises {
            self.usersDBRef.child("ExerciseList").child(training.trainingID).child(trainingComponent.exercise.exerciseID).updateChildValues([
                "name" : trainingComponent.exercise.exerciseName,
                "createdByUser" : trainingComponent.exercise.exerciseCreatedByUser,
                "numberOfSeries" : trainingComponent.exerciseNumberOfSeries])
        }
    }
    //MARK: Download list of trainings, and store this data in enviroment
    func downloadTrainingsFromDB(userID: String, completion: @escaping (Bool)->()) {
        
        var ids = [String]()
        var names = [String]()
        var descriptions = [String]()
        var dates = [String]()
        var isActivesArray = [Bool]()
        var allExercises = [[TrainingsComponent]]()
        var datesOfTraining = [[Date]]()
        var trainings = [Training]()
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
                                let isTrainingActive = trainingInfo["isTrainingActive"] as! Bool
                                
                                ids.append(trainingID.key)
                                names.append(name)
                                descriptions.append(description)
                                dates.append(date)
                                isActivesArray.append(isTrainingActive)
                            }
                        }
                        self.usersDBRef.child("ExerciseList").child(trainingID.key).observeSingleEvent(of: .value) { (exerciseSnapshot) in
                            var trainingComponents = [TrainingsComponent]()
                            for child in exerciseSnapshot.children {
                                let exerciseInfo = child  as! DataSnapshot
                                let dict = exerciseInfo.value as! [String : Any]
                                
                                let trainingComponent = TrainingsComponent(exercise: Exercise(id: exerciseInfo.key as String,
                                                                                              name: dict["name"] as! String,
                                                                                              createdByUser: dict["createdByUser"] as! Bool),
                                                                           numberOfSeries: dict["numberOfSeries"] as! Int,
                                                                           orderInList: dict["order"] as! Int)
                                
                                trainingComponents.append(trainingComponent)
                                trainingComponents = trainingComponents.sorted(by: { $0.exerciseOrderInList < $1.exerciseOrderInList })
                            }
                            allExercises.append(trainingComponents)
                            self.downloadTrainingSessionsFromDB(userID: userID, trainingID: trainingID.key) { (trainingDates) in
                                datesOfTraining.append(trainingDates)
                                
                                
                                let training = Training(id: ids[index],
                                                        name: names[index],
                                                        description: descriptions[index],
                                                        date: dates[index],
                                                        exercises: allExercises[index],
                                                        trainingDates: datesOfTraining[index],
                                                        isTrainingActive: isActivesArray[index])
                                trainings.append(training)
                                index += 1
                                if ids.count == index {
                                    self.userSession?.userTrainings = trainings
                                    completion(true)
                                }
                            }
                            
                        }
                    }
                }
            } else {
                completion(true)
            }
        }
    }
    
    func deleteTrainingFromDB(userID: String, training: Training, completion: @escaping (Bool, String?)->()) {

        self.usersDBRef.child("Trainings").child(training.trainingID).removeValue() { error, _ in
            if error != nil {
                completion(true, error?.localizedDescription)
            } else {
                print("Data for path: [Trainings/...] removed successfully!")
                completion(false, nil)
            }
        }
        
        self.usersDBRef.child("UsersTrainings").child(userID).child(training.trainingID).removeValue() { error, _ in
            if error != nil {
                completion(true, error?.localizedDescription)
            } else {
                print("Data for path: [UsersTrainings/...] removed successfully!")
                completion(false, nil)
            }}
        self.usersDBRef.child("ExerciseList").child(training.trainingID).removeValue() { error, _ in
            if error != nil {
                completion(true, error?.localizedDescription)
            } else {
                print("Data for path: [ExerciseList/...] removed successfully!")
                completion(false, nil)
            }
        }
        
    }
    
    func uploadUserStatisticsToDB(userID: String, statistics: ExerciseStatistics, completion: @escaping (Bool, String?)->()) {
        
        let id = statistics.exercise.exerciseID
        let name = statistics.exercise.exerciseName
        let createdByUser = statistics.exercise.exerciseCreatedByUser
        
        self.usersDBRef.child("UserStatistics").child(userID).child(id).setValue([
                                                                                    "name" : name,
                                                                                    "createdByUser" : createdByUser]) {
            
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data path: [UserStatistics/...] could not be saved: \(error.localizedDescription).")
                completion(true, error.localizedDescription)
            } else {
                print("Data path: [UserStatistics/...] saved successfully!")
                completion(false, nil)
            }
        }
        
        for data in statistics.exerciseData {
            
            let dateString = DateConverter.dateFormat.string(from: data.exerciseDate)
            let dataID = data.exerciseDataID
            
            
            self.usersDBRef.child("UserExercisesData").child(userID).child(id).child(dataID).setValue(dateString) {
                
                (error:Error?, ref:DatabaseReference) in
                if let error = error {
                    print("Data path: [UserExercisesData/...] could not be saved: \(error.localizedDescription).")
                    completion(true, error.localizedDescription)
                } else {
                    print("Data path: [UserExercisesData/...] saved successfully!")
                    completion(false, nil)
                }
            }
            
            for seriesDetails in data.exerciseSeries {
                
                let seriesID = seriesDetails.seriesID
                let orderInSeries = seriesDetails.orderInSeries
                let reps = seriesDetails.exerciseRepeats
                let weight = seriesDetails.exerciseWeight
                
                self.usersDBRef.child("Series").child(dataID).child(seriesID).setValue([
                                                                                        "order" : orderInSeries,
                                                                                        "repeats" : reps,
                                                                                        "weight" : weight]) {
                    
                    (error:Error?, ref:DatabaseReference) in
                    if let error = error {
                        print("Data path: [Series/...] could not be saved: \(error.localizedDescription).")
                        completion(true, error.localizedDescription)
                    } else {
                        print("Data path: [Series/...] saved successfully!")
                        completion(false, nil)
                    }
                }
            }
        }
    }
    
    func downloadUserStatisticsFromDB(userID: String, completion: @escaping (Bool)->()) {
        
        var exerciseIDs = [String]()
        var exerciseNames = [String]()
        var exerciseAsUserCreations = [Bool]()
        var exercisesData = [[ExerciseData]]()
        var exerciseStatistics = [ExerciseStatistics]()
        var index = 0
        var size = 0
        
        self.usersDBRef.child("UserStatistics").child(userID).observeSingleEvent(of: .value) { (userStatsSnapShot) in
            
            if userStatsSnapShot.exists() {
                if let snapChildren = userStatsSnapShot.children.allObjects as? [DataSnapshot] {
                    
                    size = snapChildren.count
                    
                    for child in snapChildren {
                        
                        var exerciseData = [ExerciseData]()
                        
                        if let statsDict = child.value as? [String : Any] {
                            let exerciseID = child.key
                            let exerciseName = statsDict["name"] as! String
                            let exerciseCreatedByUser = statsDict["createdByUser"] as! Bool
                            
                            exerciseIDs.append(exerciseID)
                            exerciseNames.append(exerciseName)
                            exerciseAsUserCreations.append(exerciseCreatedByUser)
                            
                            self.usersDBRef.child("UserExercisesData").child(userID).child(exerciseID).observeSingleEvent(of: .value) { (exerciseDataSnapshot) in
                                if let snapDataChildren = exerciseDataSnapshot.children.allObjects as? [DataSnapshot] {
                                    for childData in snapDataChildren {
                                        let exerciseDataID = childData.key
                                        let exerciseDate = DateConverter.convertFromString(dateString: childData.value as! String)
                                        
                                        exerciseData.append(ExerciseData(dataID: exerciseDataID,
                                                                         date: exerciseDate,
                                                                         series: [Series]()))
                                    }
                                    exercisesData.append(exerciseData)
                                }
                                
                                let exerciseStatistic = ExerciseStatistics(exercise: Exercise(id: exerciseIDs[index],
                                                                                              name: exerciseNames[index],
                                                                                              createdByUser: exerciseAsUserCreations[index]),
                                                                           data: exercisesData[index].sorted(by: {$0.exerciseDate < $1.exerciseDate}))
                                //self.userSession?.userStatistics.append(exerciseStatistic)
                                exerciseStatistics.append(exerciseStatistic)
                                
                                index += 1
                                
                                if index == size
                                {
                                    self.userSession?.userStatistics = exerciseStatistics
                                    completion(true)
                                }
                            }
                        }
                    }
                }
            } else {
                completion(true)
            }
        }
    }
    
    func downloadSeriesFromDB(userID: String, exerciseDataID: String, completion: @escaping (Bool)->()) {
        self.usersDBRef.child("Series").child(exerciseDataID).observeSingleEvent(of: .value) { (seriesSnapshot) in
            
            var series = [Series]()
            
            if let seriesSnapChildren = seriesSnapshot.children.allObjects as? [DataSnapshot] {
                for seriesSnapChild in seriesSnapChildren {
                    
                    let seriesDict = seriesSnapChild.value as! [String : Any]
                    let seriesID = seriesSnapChild.key
                    let orederInSeries = seriesDict["order"] as! Int
                    let repeats = seriesDict["repeats"] as? Int
                    let weight = seriesDict["weight"] as? Int
                    
                    let singleSeries = Series(id: seriesID,
                                              order: orederInSeries,
                                              repeats: repeats ?? 1,
                                              weight: weight ?? 0)
                    series.append(singleSeries)
                }
                series = series.sorted(by: {$0.orderInSeries < $1.orderInSeries })
                
                
                if let exerciseIndex = self.userSession?.userStatistics.firstIndex(where: {
                                                                                    ($0.exerciseData.firstIndex(where: {
                                                                                        $0.exerciseDataID == exerciseDataID
                                                                                    }) != nil) == true }) {
                    
                    if let exerciseDataIndex = self.userSession?.userStatistics[exerciseIndex].exerciseData.firstIndex(where: {
                        $0.exerciseDataID == exerciseDataID
                    }) {
                        //self.userSession?.userStatistics[exerciseIndex!].exerciseData[exerciseDataIndex!].exerciseSeries.append(contentsOf: series)
                        self.userSession?.userStatistics[exerciseIndex].exerciseData[exerciseDataIndex].exerciseSeries = series
                    }
                }
                
                
            }
            completion(true)
        }
    }
    
    func deleteSingleStataisticsFromDB(userID: String, statistics: ExerciseStatistics, completion: @escaping (Bool, String?)->()) {
        
        let exerciseID = statistics.exercise.exerciseID
        
        self.usersDBRef.child("UserStatistics").child(userID).child(exerciseID).removeValue() { error, _ in
            if error != nil {
                completion(true, error?.localizedDescription)
            } else {
                print("Data for path: [UserStatistics/...] removed successfully!")
                completion(false, nil)
            }
        }
        self.usersDBRef.child("UserExercisesData").child(userID).child(exerciseID).removeValue() { error, _ in
            if error != nil {
                completion(true, error?.localizedDescription)
            } else {
                print("Data for path: [UserExercisesData/...] removed successfully!")
                completion(false, nil)
            }
        }
        for exerciseData in statistics.exerciseData {
            let exerciseDataID = exerciseData.exerciseDataID
            self.usersDBRef.child("Series").child(exerciseDataID).removeValue() { error, _ in
                if error != nil {
                    completion(true, error?.localizedDescription)
                } else {
                    print("Data for path: [Series/...] removed successfully!")
                    completion(false, nil)
                }
            }
        }
    }
    
    func deleteDayOfTraining(userID: String, training: Training, forDay: Date, completion: @escaping (Bool, String?)->()) {
        
        var isTheLastTrainingSession: Bool {
            if training.trainingDates.count == 1 {
                return true
            } else {
                return false
            }
        }
        var counter = 0
        
        for date in training.trainingDates {
            if date == forDay {
                let dateAsString = DateConverter.dateFormat.string(from: date)
                self.usersDBRef.child("UserTrainingSessions").child(userID).child(training.trainingID).child(dateAsString).removeValue()

                for exercise in training.listOfExercises {
                    self.usersDBRef.child("UserExercisesData").child(userID).child(exercise.exercise.exerciseID).observeSingleEvent(of: .value) { (dataSnapShot) in
                        
                        if let listOfExerciseData = dataSnapShot.children.allObjects as? [DataSnapshot] {

                            if listOfExerciseData.count == 1 {
                                self.usersDBRef.child("UserStatistics").child(userID).child(exercise.exercise.exerciseID).removeValue()
                            }

                            for exerciseData in listOfExerciseData {
                                let exerciseDataDate = exerciseData.value as! String
                                let exerciseDataID = exerciseData.key
                                if exerciseDataDate == dateAsString {
                                    self.usersDBRef.child("UserExercisesData").child(userID).child(exercise.exercise.exerciseID).child(exerciseDataID).removeValue()
                                    self.usersDBRef.child("Series").child(exerciseDataID).removeValue()
                                    counter += 1
                                }
                                
                            }
                        }
                    }
                }
                if isTheLastTrainingSession && !training.isTrainingActive {
                    self.deleteTrainingFromDB(userID: userID, training: training) { (error, errorDescription) in
                        if !error {
                            counter += 1
                        }
                    }
                } else {
                    counter += 1
                }
                if counter == 2 {
                    completion(true, nil)
                }
            }
        }
    }
    
    func uploadCalendarNote(userID: String, calendarNote: CalendarNote, completion: @escaping (Bool, String?)->()) {
        
        let noteDateString = DateConverter.dateFormat.string(from: calendarNote.notesDate)
        
        self.usersDBRef.child("UserNotes").child(userID).child(calendarNote.notesID).setValue([
            "note" : calendarNote.note,
            "date" : noteDateString,
            "isCompleted" : calendarNote.isCompleted
        ]) { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data path: [UserNotes/...] could not be saved: \(error.localizedDescription)")
                completion(true, error.localizedDescription)
            } else {
                print("Data path: [UserNotes/...] saved successfully!")
                completion(false, nil)
            }
        }
    }
    func updateCalendarNote(userID: String, calendarNote: CalendarNote) {
        
        let noteDateString = DateConverter.dateFormat.string(from: calendarNote.notesDate)
        
        self.usersDBRef.child("UserNotes").child(userID).child(calendarNote.notesID).updateChildValues([
            "note" : calendarNote.note,
            "date" : noteDateString,
            "isCompleted" : calendarNote.isCompleted
        ]) { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data path: [UserNotes/...] could not be updated: \(error.localizedDescription)")
            } else {
                print("Data path: [UserNotes/...] updated successfully!")
            }
        }
    }
    
    func downloadCalendarNote(userID: String, completion: @escaping (Bool)->()) {
        
        self.usersDBRef.child("UserNotes").child(userID).observeSingleEvent(of: .value) { noteSnapshot in
            var notes = [CalendarNote]()
            var counter = 0
            
            if let noteSnapChildren = noteSnapshot.children.allObjects as? [DataSnapshot] {
                
                for note in noteSnapChildren {
                    let noteID = note.key
                    if let noteData = note.value as? [String : Any] {
                        let noteDate = noteData["date"] as! String
                        let noteText = noteData["note"] as! String
                        let isCompleted = noteData["isCompleted"] as! Bool
                        
                        let dateAsDate = DateConverter.convertFromString(dateString: noteDate)
                        
                        let calendarNote = CalendarNote(notesID: noteID,
                                                notesDate: dateAsDate,
                                                note: noteText,
                                                isCompleted: isCompleted)
                        notes.append(calendarNote)
                        counter += 1
                        
                        if counter == noteSnapChildren.count {
                            self.userSession?.userCalendar = notes
                            completion(true)
                        }
                    }
                }
            }
        }
    }
    func deleteCalendarNoteFromDB(userID: String, note: CalendarNote) {
        self.usersDBRef.child("UserNotes").child(userID).child(note.notesID).removeValue() { error, _ in
            if error != nil {
                print("Error during delete action on note: \(String(describing: error?.localizedDescription))")
            } else {
                print("Data for path: [UserStatistics/...] removed successfully!")
            }
        }
    }
    
    func uploadTreningSessionToDB(userID: String, trainingID: String, trainingDate: Date, completion: @escaping (Bool, String?)->()) {
        
        let currentDateString = DateConverter.dateFormat.string(from: trainingDate)
        
        self.usersDBRef.child("UserTrainingSessions").child(userID).child(trainingID).child(currentDateString).setValue(1)
        { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data path: [UserTrainingSessions/...] could not be saved: \(error.localizedDescription)")
                completion(true, error.localizedDescription)
            } else {
                print("Data path: [UserTrainingSessions/...] saved successfully!")
                completion(false, nil)
            }
        }
    }
    
    func downloadTrainingSessionsFromDB(userID: String, trainingID: String, completion: @escaping ([Date])->()) {
        var dates = [Date]()
        var counter = 0
        
        self.usersDBRef.child("UserTrainingSessions").child(userID).child(trainingID).observeSingleEvent(of: .value) { (sessionSnapshot) in
            if sessionSnapshot.exists() {
                if let ssessionSnapChildren = sessionSnapshot.children.allObjects as? [DataSnapshot] {
                    for sigleSnap in ssessionSnapChildren {
                        let dateAsDate = DateConverter.convertFromString(dateString: sigleSnap.key)
                        dates.append(dateAsDate)
                        counter += 1
                        
                        if counter == ssessionSnapChildren.count {
                            completion(dates)
                        }
                    }
                } else {
                    completion([Date]())
                }
                
            } else {
                completion([Date]())
            }
        }
    }
    func deleteTrainingSessionsFromDB(userID: String, completion: @escaping (Bool)->()) {
        self.usersDBRef.child("UserTrainingSessions").child(userID).removeValue() { error, _ in
            if error != nil {
                print("Error during delete action UserTrainingSessions: \(String(describing: error?.localizedDescription))")
                completion(true)
            } else {
                print("Data for path: [UserTrainingSessions/...] removed successfully!")
                completion(false)
            }
        }
    }
}


