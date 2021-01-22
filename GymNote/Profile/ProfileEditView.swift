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
    @Binding var imageHasBeenDeleted: Bool
    
    //var to change photo mechanics
    @State var doneUpdating = false
    @State var doneChangingPhoto = false
    @State var doDeleteAction = false
    
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
                                
                                RectangularImage(image: Image(uiImage: profile.userImage))
                                    .padding(.top, 20)
                                    .padding(.bottom, 15)
                                ChangeButton(isChanged: $doneChangingPhoto,
                                             changeAction: {
                                                if imageHasBeenDeleted {
                                                    imageHasBeenDeleted = false
                                                }
                                             })
                            
                                    .offset(x: 60, y: 60)
                                    .scaleEffect(1.2)
                                //TODO: do not display delete button if there is image there
                                ChangeButton(isChanged: self.$doDeleteAction,
                                             changeAction: {},
                                             changesButtonImage: Image(systemName: "trash"),
                                             foregroundColor: Color.red)
                                    .buttonStyle(BorderlessButtonStyle())
                                    .scaleEffect(0.7)
                                    .offset(x: -UIScreen.main.bounds.width/6 - 8,
                                            y: -UIScreen.main.bounds.width/6 - 8)
                                
                                
                            }
                            .padding(.bottom, 15)
                            
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
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: .leading, endPoint: .trailing))
                            .frame(width: UIScreen.main.bounds.size.width-52, height: 32)
                            .shadow(color: Color.black, radius: 3)
                        
                        
                        Picker(
                            selection: $profile.userHeight,
                            label: EmptyView()) {
                            
                            ForEach(self.userPossibleHeight, id: \.self) { height in
                                Text("\(height) cm")
                                
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .labelsHidden()
                        .frame(width: UIScreen.main.bounds.size.width-40)
                        .clipped()
                        
                    }
                    
                }
                Section(header: Text("Gender")) {
                    Picker(
                        selection: self.$profile.userGender,
                        label: EmptyView()) {
                        
                        ForEach(Gender.allCases, id: \.self) {
                            Text("\($0.rawValue)").tag($0.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .background(LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(7)
                    .shadow(color: Color.black, radius: 3)
                    .padding(.vertical)
                }
                
                
                Section(header: Text("Date of birth")) {
                    
                    DatePicker(
                        selection: $profile.userDateOfBirth,
                        in: ...Date(),
                        displayedComponents: .date) {
                        
                        Text("Enter your date of birth: ")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    
                }
            }.listStyle(GroupedListStyle())
            
            if doneChangingPhoto || doDeleteAction {
                Color.black.opacity(0.7)
            }
            if doneChangingPhoto {
                CaptureImageView(isShown: $doneChangingPhoto,
                                 image: $profile.userImage)
            }
            if doDeleteAction {
                ActionAlert(showAlert: $doDeleteAction,
                            title: "Warning",
                            message: "You want to delete the photo?",
                            firstButtonTitle: "Yes",
                            secondButtonTitle: "Cancel",
                            action: {
                                self.deleteImageFromDraftProfile()
                                self.doDeleteAction = false
                            })
                    .shadow(color: Color.customShadow, radius: 5)
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
    func deleteImageFromDraftProfile() {
        profile.userImage = UIImage(named: "staticImage")!
        imageHasBeenDeleted = true
    }
    func isImageEqual(image1: UIImage, isEqualTo image2: UIImage) -> Bool {
        let data1: NSData = image1.pngData()! as NSData
        let data2: NSData = image2.pngData()! as NSData
        return data1.isEqual(data2)
    }
}

struct ProfileEditView_Previews: PreviewProvider {
    
    @State static var prevProfile = UserProfile()
    @State static var prevDoneUpdating = false
    @State static var imageHasBeenRemoved = false
    
    static var previews: some View {
        NavigationView {
            ProfileEditView(profile: $prevProfile,
                            imageHasBeenDeleted: $imageHasBeenRemoved)
        }
    }
}

enum Gender: String, CaseIterable {
    case non
    case male
    case female
}

