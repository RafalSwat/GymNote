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
    
    var body: some View {
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
            
            List {
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
                    }
                    HStack {
                        Text("Height:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(profile.userHeight, specifier: "%.f") cm")
                    }
                    HStack {
                        Text("Gender:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("non")
                    }
                    HStack {
                        Text("Date of birth:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(ProfileView.dateFormat.string(from: profile.dateOfBirth))")
                    }
                }
            }
        }
    }

}

struct ProfileEditView_Previews: PreviewProvider {
    
    @State static var profile = UserProfile.default
    
    static var previews: some View {
        ProfileEditView(profile: $profile)
    }
}
