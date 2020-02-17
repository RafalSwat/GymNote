//
//  ProfileEditView.swift
//  GymNote
//
//  Created by Rafał Swat on 23/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ProfileEditView: View {
    
    @Binding var profile: UserProfile
    @State var doneUpdating = false
    @State var doneChangingPhoto = false
    @State var tempUserProfile = UserProfile.default
    
    //Array only for pick the height and gender of a user
    var userPossibleHeight = Array(40...250)
    var userPossibleGender = ["male", "female", "non"]
    
    
    var body: some View {
        
        KeyboardHost {
            ZStack {
                List {
                    Section(header: Text("Profile picture")) {
                        HStack{
                            Spacer()
                            VStack {
                                ZStack {
                                    
                                    CircleImage(image: tempUserProfile.userImage)
                                        .padding(.top, 50)
                                        .padding(.bottom, 15)
                                    ChangeButton(isChanged: $doneChangingPhoto)
                                        .offset(x: 40, y: 50)
                                        .scaleEffect(1.7)
                                }
                                Text("\(tempUserProfile.userName) \(tempUserProfile.userSurname)")
                                    .font(.title)
                            }
                            Spacer()
                        }
                    }
                    
                    Section(header: Text("Basic info")) {
                        HStack {
                            Text("Name:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            TextField("Enter your name: ", text: $tempUserProfile.userName)
                        }
                        HStack {
                            Text("Surname: ")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            TextField("Enter your surname: ", text: $tempUserProfile.userSurname)
                        }}
                    Section(header: Text("Height")) {
                        Picker(
                            selection: $tempUserProfile.userHeight,
                            label: Text("")) {
                                ForEach(0 ..< userPossibleHeight.count) {
                                    //FIXME: "-40" because for unknown reasons, the picker chooses a number that is exactly 40 different
                                    Text("\(self.userPossibleHeight[$0] - 40) cm")
                                }
                        }.pickerStyle(WheelPickerStyle())
                        
                        
                    }
                    Section(header: Text("Gender")) {
                        Picker(
                            selection: $tempUserProfile.userGender,
                            label: Text("")) {
                                ForEach(0 ..< userPossibleGender.count) {             Text("\(self.userPossibleGender[$0])")
                                }
                        }.pickerStyle(SegmentedPickerStyle())
                            .padding(.vertical)
                        
                    }
                    Section(header: Text("Date of birth")) {
                        DatePicker(
                            selection: $tempUserProfile.dateOfBirth,
                            in: ...Date(),
                            displayedComponents: .date) {
                                Text("")
                        }
                        
                    }
                }
                    
                    
                    
                .navigationBarTitle("Edit Profile", displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(
                    leading: BackButton(),
                    trailing: DoneButton(isDone: $doneUpdating)
                )
                if (doneUpdating) {
                    ZStack {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.vertical)
                        GeometryReader { geometry in
                            DoneConformAlert(showAlert: self.$doneUpdating, alertTitle: "", alertMessage: "MESS", alertAction: {
                                //TODO: updating stuff!
                                self.updateOfflineData()
                                self.doneUpdating.toggle()
                                
                            })
                            .padding()
                            .position(x: geometry.size.width/2, y: geometry.size.height/2)
                        }
                    }
                }
                
                if (doneChangingPhoto) {
                    CaptureImageView(isShown: $doneChangingPhoto, image: $profile.userImage)
                }
            }
            
      }
        .onAppear {
            self.tempUserProfile = self.profile
        }
    }
    func updateOfflineData() {
        self.profile.userImage = self.tempUserProfile.userImage
        self.profile.userName =  self.tempUserProfile.userName
        self.profile.userSurname = self.tempUserProfile.userSurname
        self.profile.userHeight = self.tempUserProfile.userHeight
        self.profile.userGender = self.tempUserProfile.userGender
        self.profile.dateOfBirth = self.tempUserProfile.dateOfBirth
    }
    
}

struct ProfileEditView_Previews: PreviewProvider {
    
    @State static var profile = UserProfile.default
    
    static var previews: some View {
        NavigationView {
            ProfileEditView(profile: $profile)
        }
        
    }
}
