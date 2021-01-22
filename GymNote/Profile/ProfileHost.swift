//
//  ProfileHost.swift
//  GymNote
//
//  Created by Rafał Swat on 30/05/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ProfileHost: View {

    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Profile.entity(), sortDescriptors: []) var imageCoreData: FetchedResults<Profile>
    
    @EnvironmentObject var session: FireBaseSession
    
    @State var draftProfile = UserProfile()
    @State var editMode = false
    @State var image: UIImage = UIImage(named: "staticImage")!
    @State var didAppear = false
    @State var imageHasBeenRemoved = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                
                if !self.editMode {
                    ProfileView(image: self.$image, profile: session.userSession?.userProfile ?? UserProfile())
                        .onAppear {
                            if !self.didAppear {
                                print("---> ProfileView: onAppear")
                                //DispatchQueue.main.async {
                                    self.setupImage()
                                //}
                                self.didAppear = true
                            }
                        }
                } else {
                    ProfileEditView(profile: $draftProfile,
                                    imageHasBeenDeleted: $imageHasBeenRemoved)
                        .onAppear {
                            self.draftProfile = self.session.userSession?.userProfile ?? UserProfile()
                        }
                }
            }
            .navigationBarItems(
                leading: CancelEditModeButton(editMode: $editMode, cancelAction: {
                    self.draftProfile = self.session.userSession?.userProfile ?? UserProfile()
                }),
                trailing: EditModeButton(editMode: $editMode, editAction: {
                    
                    if self.session.userSession?.userProfile.userImage != self.draftProfile.userImage && !self.imageHasBeenRemoved {
                        self.draftProfile.lastImageActualization = Date()
                        self.saveImageToCoreData(userID: self.draftProfile.userID,
                                                 userImage: self.draftProfile.userImage,
                                                 userActualization: self.draftProfile.lastImageActualization ?? Date())
                        self.session.uploadImageToDB(uiimage: self.draftProfile.userImage,
                                                     id: self.draftProfile.userID)
                        self.image = self.draftProfile.userImage
                    }
                    
                    if self.imageHasBeenRemoved {
                        if let userID = self.session.userSession?.userProfile.userID {
                            self.draftProfile.lastImageActualization = Date()
                            session.deleteImagefromFirebase(id: userID)
                            deleteImageFromCoreData(id: userID)
                        }
                        self.image = self.draftProfile.userImage
                    }
                    self.session.userSession?.userProfile = self.draftProfile
                    self.session.updateProfileOnDB(user: self.draftProfile)
                })
            )
        }
    }
    
    //MARK: save image inside CoreData
    func saveImageToCoreData(userID: String, userImage: UIImage, userActualization: Date) {

        if userImage != UIImage(named: "staticImage")! {
            if imageCoreData.isEmpty {
                let profile = Profile(context: moc)
                profile.userID = userID
                profile.image = userImage.jpegData(compressionQuality: 0.3)
                profile.lastImageActualization = userActualization
            } else {
                for user in self.imageCoreData {
                    if user.userID == userID {
                        user.image = userImage.jpegData(compressionQuality: 0.3)
                        user.lastImageActualization = Date()
                    } else {
                        let profile = Profile(context: moc)
                        profile.userID = userID
                        profile.image = userImage.jpegData(compressionQuality: 0.3)
                        profile.lastImageActualization = Date()
                    }
                }
            }
            
            
            do {
                try self.moc.save()
                print("Saving Image To CoreData!")
            } catch {
                print("Error while saving managedObjectContext \(error.localizedDescription)")
            }
        }
    }
    func setupImage() {
        if let userID = self.session.userSession?.userProfile.userID {
            downloadImageFromCoreData(id: userID, completion: { image, lastActuazlization, coreDataDownloadingSuccessful in
                if coreDataDownloadingSuccessful == true {
                    print("---> ther is some data in core data")
                    let fbrDateOfActualization = self.session.userSession?.userProfile.lastImageActualization
                    if fbrDateOfActualization == lastActuazlization || fbrDateOfActualization! < lastActuazlization! {
                        print("fbrDateOfActualization == lastActuazlization && fbrDateOfActualization! > lastActuazlization! ---> TRUE")
                        if let coreDataImage = image {
                            self.session.userSession?.userProfile.userImage = coreDataImage
                            self.session.userSession?.userProfile.lastImageActualization = lastActuazlization
                            self.image = coreDataImage
                            print("---> ProfileHost: setupImage - CoreData")
                        }
                    } else {
                        self.downloadImageFromFirebase(userID: userID)
                    }
                } else {
                    self.downloadImageFromFirebase(userID: userID)
                }
            })
        }
    }
    
    
    //MARK: Download Image form CoreData, if Not FireBase if not put ststic Image
    func downloadImageFromCoreData(id: String, completion: @escaping (UIImage?, Date?, Bool)->()) {
        if !imageCoreData.isEmpty {
            for img in imageCoreData {
                print("----> how many: \(imageCoreData.count)")
                if img.userID == id {
                    if let image = img.image {
                        if let imgCoreData = UIImage(data: image) {
                            completion(imgCoreData, img.lastImageActualization, true)
                        } else {
                            completion(nil, nil, false)
                            return
                        }
                    } else {
                        completion(nil, nil, false)
                        return
                    }
                } else {
                    completion(nil, nil, false)
                    return
                }
            }
        } else {
            completion(nil, nil, false)
            return
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
    func downloadImageFromFirebase(userID: String) {
        self.session.downloadImageFromDB(id: userID, completion: { fireBaseImage in
            self.session.userSession?.userProfile.userImage = fireBaseImage
            self.image = fireBaseImage
            print("---> ProfileHost: setupImage - Firebase")
            
            self.saveImageToCoreData(userID: userID,
                                     userImage: fireBaseImage,
                                     userActualization: self.session.userSession?.userProfile.lastImageActualization ?? Date())
        })
    }
}



struct ProfileHost_Previews: PreviewProvider {
    
    @State static var prevSession = FireBaseSession()
    
    static var previews: some View {
        ProfileHost()
            .environmentObject(prevSession)
        
    }
}



