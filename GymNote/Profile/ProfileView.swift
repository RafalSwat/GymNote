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
    
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    var body: some View {
        VStack {
            
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
                Section(header: Text("Training level")) {
                    Text("Training level: beginner")
                }
            }.listStyle(GroupedListStyle())
            .navigationBarTitle("Profile", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            //FIXME: there is a problem with second button, dont appear (they do appear on real device so the problem must by on previews)
            .navigationBarItems(
                leading: BackButton(),
                trailing: CustomEditButton()
            )
        }
        
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView(profile: UserProfile.default)
        }
        
    }
}
