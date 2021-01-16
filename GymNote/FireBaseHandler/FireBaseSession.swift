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
    
    //-------------------- CoreData - Only Image Handling ----------------------
    
    @Environment(\.managedObjectContext) var moc
    //After fetch request we can use data from CoreData if there is any
    @FetchRequest(entity: Profile.entity(), sortDescriptors: []) var imageCoreData: FetchedResults<Profile>
    //-------------------- Error properties handler ----------------------------
    
    var handle: AuthStateDidChangeListenerHandle?
    
    func setupErrorDescription(errorString: String, errorDescription: @escaping (String)->()) {
        errorDescription(errorString)
    }
    
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
            } else {
                if let specificError = error?.localizedDescription {
                    print(specificError)
                } else {
                    print("Error:  can`t register!")
                }
            }
        }
    }
    //MARK: Signin method
    func signIn(email: String, password: String, completion: @escaping (Bool, String?)->()) {
        Auth.auth().signIn(withEmail: email, password: password) {
            (user, error) in
            
            if error != nil {
                completion(true, error?.localizedDescription)
            } else {
                completion(false, error?.localizedDescription)
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
                    
                    self.downloadImageFromCDOrDB(id: userID, completion: { downloadedImage in
                        
                        let userProfile = UserProfile(uID: userID,
                                                      email: userEmail,
                                                      name: value["name"] as! String,
                                                      surname: value["surname"] as! String,
                                                      gender: value["gender"] as! String,
                                                      profileImage: downloadedImage,
                                                      height: value["height"] as! Int,
                                                      userDateOfBirth: convertDate)
                        self.userSession = UserData(profile: userProfile)
                        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                        print("\n\(dataFilePath)\n")
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
                    self.uploadUserToDB(user: newUser, completion: {_ in }) //TODO: do sth with this completion!!! you lazy bastard 
                }
            }
        }
    }
    //MARK: Adding new user to data base
    func uploadUserToDB(user: UserProfile, completion: @escaping (Bool)->()) {
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
        saveImageToCDAndDB(uiimage: user.userImage, id: user.userID)
    }
    
    //MARK: Update profile for current user on DB
    func updateProfileOnDB(user: UserProfile) {
        usersDBRef.child("Users").child(user.userID).child("Profile").updateChildValues(
            ["name" : user.userName,
             "surname" : user.userSurname,
             "dateOfBirth" : DateConverter.dateFormat.string(from: user.userDateOfBirth),
             "gender" : user.userGender,
             "height" : user.userHeight])
        saveImageToCDAndDB(uiimage: user.userImage, id: user.userID)
    }
    
    //MARK: save image inside CoreData and Firebase ( is used inside updating profile method)
    func saveImageToCDAndDB(uiimage: UIImage, id: String) {
        let imageCoreData = Profile(context: self.moc)
        imageCoreData.userID = id
        imageCoreData.image = uiimage.jpegData(compressionQuality: 0.3)
        
        do {
            try self.moc.save()
        } catch {
            print("Error while saving managedObjectContext \(error.localizedDescription)")
        }
        uploadImageToDB(uiimage: uiimage, id: id)
    }
    
    
    //MARK: Upload image to Firebase
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
    
    //MARK: Download Image form CoreData, if Not FireBase if not put ststic Image
    func downloadImageFromCDOrDB(id: String, completion: @escaping (UIImage)->()) {
        if !imageCoreData.isEmpty {

            for img in imageCoreData {
                if img.userID == id {
                    if let image = img.image {
                        if let imgCoreData = UIImage(data: image) {
                            completion(imgCoreData)
                        } else {
                            self.downloadImageFromDB(id: id, completion: { imageFromFireBase in
                                completion(imageFromFireBase)
                            })
                        }
                    } else {
                        self.downloadImageFromDB(id: id, completion: { imageFromFireBase in
                            completion(imageFromFireBase)
                        })
                    }
                } else {
                    self.downloadImageFromDB(id: id, completion: { imageFromFireBase in
                        completion(imageFromFireBase)
                    })
                }
            }
        } else {
            self.downloadImageFromDB(id: id, completion: { imageFromFireBase in
                completion(imageFromFireBase)
            })
        }
    }
    
    //MARK: Download Image form FireBase
    func downloadImageFromDB(id: String, completion: @escaping (UIImage)->()){
        usersDBStorage.child("Images").child(id).getData(maxSize: 10*1024*1024) { (imageData, error) in
            if let err = error {
                print("Could`t get image data from FireBase DataBase!: \(err.localizedDescription)")
                completion(UIImage(named: "staticImage")!)
            } else {
                if let image = imageData {
                    completion(UIImage(data: image)!)
                } else {
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
    func uploadTrainingToDB(userID: String, training: Training, completion: @escaping (Bool, String?)->()) {
        
        // Upload training under current user
        self.usersDBRef.child("UsersTrainings").child(userID).child(training.trainingID).setValue(1) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data path: [UserTrainings/...] could not be saved: \(error.localizedDescription).")
                //errorDescription = error.localizedDescription
                completion(true, error.localizedDescription)
            } else {
                print("Data path: [UserTrainings/...] saved successfully!")
                //errorUserTrainings = false
                completion(false, nil)
            }
        }
        
        // Upload basic info about training (no sepcific membership)
        self.usersDBRef.child("Trainings").child(training.trainingID).setValue(
            ["name" : training.trainingName,
             "description" : training.trainingDescription,
             "initialDate" : training.initialDate]) {
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
             "initialDate" : training.initialDate]
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
        var allExercises = [[TrainingsComponent]]()
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
                            
                            let training = Training(id: ids[index],
                                                    name: names[index], // FIXME: index out of range
                                                    description: descriptions[index],
                                                    date: dates[index],
                                                    exercises: allExercises[index])
                            self.userSession?.userTrainings.append(training)
                            index += 1
                            if ids.count == index {
                                completion(true)
                            }
                        }
                    }
                }
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
            
            let dataString = DateConverter.dateFormat.string(from: data.exerciseDate)
            let dataID = data.exerciseDataID
            
            
            self.usersDBRef.child("UserExercisesData").child(userID).child(id).child(dataID).setValue(dataString) {

                (error:Error?, ref:DatabaseReference) in
                if let error = error {
                    print("Data path: [UserStatistics/...] could not be saved: \(error.localizedDescription).")
                    completion(true, error.localizedDescription)
                } else {
                    print("Data path: [UserStatistics/...] saved successfully!")
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
                                        let exerciseDate = DateConverter().convertFromString(dateString: childData.value as! String)
                                        
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
                                self.userSession?.userStatistics.append(exerciseStatistic)
                                
                                index += 1
                                
                                if index == size
                                {
                                    completion(true)
                                }
                            }
                        }
                    }
                }
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
                
                
                let exerciseIndex = self.userSession?.userStatistics.firstIndex(where: {
                    ($0.exerciseData.firstIndex(where: {
                        $0.exerciseDataID == exerciseDataID
                    }) != nil) == true })
                
                let exerciseDataIndex = self.userSession?.userStatistics[exerciseIndex!].exerciseData.firstIndex(where: {
                    $0.exerciseDataID == exerciseDataID
                })
                
                self.userSession?.userStatistics[exerciseIndex!].exerciseData[exerciseDataIndex!].exerciseSeries.append(contentsOf: series)
                
            }
            completion(true)
        }
    }
}
extension FireBaseSession {
    //static let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
}
