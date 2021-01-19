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
                    ProfileEditView(profile: $draftProfile, imageHasBeenDeleted: $imageHasBeenRemoved)
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
                    self.session.userSession?.userProfile = self.draftProfile
                    self.session.updateProfileOnDB(user: self.draftProfile)
                    self.saveImageToCoreData()
                    self.image = self.draftProfile.userImage
                    if self.imageHasBeenRemoved {
                        if let userID = self.session.userSession?.userProfile.userID {
                            session.deleteImagefromFirebase(id: userID)
                            deleteImageFromCoreData(id: userID)
                        }
                    }
                })
            )
        }
    }
    
    //MARK: save image inside CoreData
    func saveImageToCoreData() {
        let userID = self.session.userSession?.userProfile.userID
        let userImage = self.session.userSession?.userProfile.userImage
        
        if userImage != UIImage(named: "staticImage") && userImage != nil {
            
            let imageCoreData = Profile(context: self.moc)
            imageCoreData.userID = userID
            imageCoreData.image = userImage!.jpegData(compressionQuality: 0.3)
            
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
            downloadImageFromCoreData(id: userID, completion: { image, coreDataDownloadingSuccessful in
                if coreDataDownloadingSuccessful == true {
                    if let coreDataImage = image {
                        self.session.userSession?.userProfile.userImage = coreDataImage
                        self.image = coreDataImage
                        print("---> ProfileHost: setupImage - CoreData")
                    }
                } else {
                    self.session.downloadImageFromDB(id: userID, completion: { fireBaseImage in
                        self.session.userSession?.userProfile.userImage = fireBaseImage
                        self.image = fireBaseImage
                        print("---> ProfileHost: setupImage - Firebase")
                    })
                }
            })
        }
    }
    
    
    //MARK: Download Image form CoreData, if Not FireBase if not put ststic Image
    func downloadImageFromCoreData(id: String, completion: @escaping (UIImage?, Bool)->()) {
        if !imageCoreData.isEmpty {

            for img in imageCoreData {
                if img.userID == id {
                    if let image = img.image {
                        if let imgCoreData = UIImage(data: image) {
                            completion(imgCoreData, true)
                        } else {
                            completion(nil, false)
                            return
                        }
                    } else {
                        completion(nil, false)
                        return
                    }
                } else {
                    completion(nil, false)
                    return
                }
            }
        } else {
            completion(nil, false)
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
}



struct ProfileHost_Previews: PreviewProvider {
    
    @State static var prevSession = FireBaseSession()
    
    static var previews: some View {
        ProfileHost()
            .environmentObject(prevSession)
        
    }
}



