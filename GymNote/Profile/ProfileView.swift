//
//  ProfileView.swift
//  GymNote
//
//  Created by Rafał Swat on 18/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    
    var profile: UserProfile
    
    var body: some View {
        
        List {

                VStack {
                    HStack {
                        Spacer()
                        CircleImage(image: profile.userImage)
                        .padding(.top, 20)
                        .padding(.bottom, 15)
                        Spacer()
                    }
                    Text("\(profile.userName) \(profile.userSurname)")
                        .font(.title)
            }
            
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
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Profile", displayMode: .inline)
    }
}

struct ProfileView_Previews: PreviewProvider {
    
    static var prevProfile = UserProfile()
    
    static var previews: some View {
        NavigationView {
            ProfileView(profile: prevProfile)
        }
    }
}
