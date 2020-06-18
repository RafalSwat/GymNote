//
//  ProfileEditView.swift
//  GymNote
//
//  Created by Rafał Swat on 23/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ProfileEditView: View {
    
    //MARK: Properties
    @EnvironmentObject var session: FireBaseSession
    @Binding var profile: UserProfile
    
    //var to change photo mechanics
    @State var doneUpdating = false
    @State var doneChangingPhoto = false
    
    //Array only for pick the height and gender of a user
    var userPossibleHeight = Array(40...250)
    var userPossibleGender = ["non", "male", "female"]
    @State var selectedGender = 0
    
    var body: some View {
        
        KeyboardHost {
            ZStack {
                List {
                    Section(header: Text("Profile picture")) {
                        HStack{
                            Spacer()
                            VStack {
                                ZStack {
                                    
                                    CircleImage(image: profile.userImage)
                                        .padding(.top, 20)
                                        .padding(.bottom, 15)
                                    ChangeButton(isChanged: $doneChangingPhoto)
                                        .offset(x: 30, y: 40)
                                        .scaleEffect(1.7)
                                }
                                Text("\(profile.userName) \(profile.userSurname)")
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
                            TextField("Enter your name: ", text: $profile.userName)
                        }
                        HStack {
                            Text("Surname: ")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            TextField("Enter your surname: ", text: $profile.userSurname)
                        }}
                    Section(header: Text("Height")) {
                        Picker(
                            selection: $profile.userHeight,
                            label: Text("")) {
                                ForEach(0 ..< userPossibleHeight.count) {
                                    //FIXME: "-40" because for unknown reasons, the picker chooses a number that is exactly 40 different
                                    Text("\(self.userPossibleHeight[$0] - 40) cm")
                                }
                        }.pickerStyle(WheelPickerStyle())
                    }
                    Section(header: Text("Gender")) {
                        Picker(
                            selection: $selectedGender,
                            label: Text("")) {
                                ForEach(0 ..< userPossibleGender.count) {             Text("\(self.userPossibleGender[$0])")
                                }
                        }
                            //FIXME: the solution is unsatisfactory because it doesn't react on "swipe", only for clicking so that without clicking the gender doesn't change ad all
                            .onTapGesture {
                                self.profile.userGender = self.userPossibleGender[self.selectedGender]
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical)
                    
                    Section(header: Text("Date of birth")) {
                        DatePicker(
                            selection: $profile.userDateOfBirth,
                            in: ...Date(),
                            displayedComponents: .date) {
                                Text("")
                        }
                    }
                }
                
                if (doneChangingPhoto) {
                    CaptureImageView(isShown: $doneChangingPhoto, image: $profile.userImage)
                }
            }
        }
        .onAppear {
            self.setupGender()
        }
        .navigationBarTitle("Edit Profile", displayMode: .inline)
    }
    
    func setupGender() {
        if self.profile.userGender == "non" {
            self.selectedGender = 0
        } else if self.profile.userGender == "male" {
            self.selectedGender = 1
        } else {
            self.selectedGender = 2
        }
    }
}

struct ProfileEditView_Previews: PreviewProvider {
    
    @State static var prevProfile = UserProfile()
    @State static var prevDoneUpdating = false
    
    static var previews: some View {
        NavigationView {
            ProfileEditView(profile: $prevProfile)
        }
    }
}

