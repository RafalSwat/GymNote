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
    //Array only for pick the height and gender of a user
    var userPossibleHeight = Array(40...250)
    var userPossibleGender = ["male", "female", "non"]
    
    
    var body: some View {
        KeyboardHost {
            List {
                Section(header: Text("Profile picture")) {
                    HStack{
                        Spacer()
                        VStack {
                            ZStack {
                                
                                CircleImage(image: profile.userImage)
                                    .padding(.top, 50)
                                    .padding(.bottom, 15)
                                ChangeButton()
                                    .offset(x: 40, y: 50)
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
                            ForEach(0 ..< userPossibleHeight.count) {              Text("\(self.userPossibleHeight[$0]) cm")
                            }
                    }.pickerStyle(WheelPickerStyle())
                    
                    
                }
                Section(header: Text("Gender")) {
                    Picker(
                        selection: $profile.userGender,
                        label: Text("")) {
                            ForEach(0 ..< userPossibleGender.count) {             Text("\(self.userPossibleGender[$0])")
                            }
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding(.vertical)
                    
                }
                Section(header: Text("Date of birth")) {
                    DatePicker(
                        selection: $profile.dateOfBirth,
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
                trailing: DoneButton()
            )
        }
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
