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
    
    //Array only for pick the height of a user
    var userPossibleHeight = Array(40...250)
    @State var selectedGender = Gender.non
    
    
    var body: some View {
        
        
        ZStack {
            List {
                Section(header: Text("Profile picture")) {
                    HStack{
                        Spacer()
                        VStack {
                            ZStack {
                                
                                CircleImage(image: Image(uiImage: profile.userImage))
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
                        label: EmptyView()) {
                        
                        ForEach(self.userPossibleHeight, id: \.self) {
                            Text("\($0) cm")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .labelsHidden()
                    .frame(width: UIScreen.main.bounds.width/1.11)
                    .clipped()
                    
                    
                }
                Section(header: Text("Gender")) {
                    Picker(
                        selection: self.$profile.userGender,
                        label: EmptyView()) {
                        
                        ForEach(Gender.allCases, id: \.self) {
                            Text("\($0.rawValue)").tag($0.rawValue)
                        }
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
            }.listStyle(GroupedListStyle())
            
            if (doneChangingPhoto) {
                CaptureImageView(isShown: $doneChangingPhoto, image: $profile.userImage)
            }
        }
        
        .onAppear {
            self.setupGender()
        }
        .navigationBarTitle("Edit Profile", displayMode: .inline)
    }
    
    func setupGender() {
        if self.profile.userGender == "female" {
            self.selectedGender = Gender.female
        } else if self.profile.userGender == "male" {
            self.selectedGender = Gender.male
        } else {
            self.selectedGender = Gender.non
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

enum Gender: String, CaseIterable {
    case non
    case male
    case female
}

