//
//  ProfileView.swift
//  GymNote
//
//  Created by Rafał Swat on 18/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    
    @State var profile: UserProfile
    @State var profileEditMode = false
        
    var body: some View {
        VStack {
            
            if profileEditMode {
                NavigationLink(destination: ProfileEditView(profile: $profile),
                               isActive: self.$profileEditMode) { Text("") }
            }
            
            CircleImage(image: profile.userImage)
                .padding(.top, 50)
                .padding(.bottom, 15)
            Text("\(profile.userName) \(profile.userSurname)")
                .font(.title)
            List {
                Section(header: Text("Basic info")) {
                    HStack {
                        Text("Email:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(profile.userEmail)
                    }
                    HStack {
                        Text("Height:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(profile.userHeight) cm")
                    }
                    HStack {
                        Text("Gender:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(profile.userGender)
                    }
                    HStack {
                        Text("Date of birth:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(DateConverter.dateFormat.string(from: profile.userDateOfBirth))")
                    }
                }
                Section(header: Text("Training level")) {
                    Text("Training level: beginner")
                }
            }.listStyle(GroupedListStyle())
            .navigationBarTitle("Profile", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: BackButton(),
                trailing: CustomEditButton(editMode: self.$profileEditMode)
            )
        }
        
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    
    @State static var prevProfile = UserProfile()
    
    static var previews: some View {
        NavigationView {
            ProfileView(profile: prevProfile)
        }
        
    }
}
