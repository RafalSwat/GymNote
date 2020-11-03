//
//  ProfileView.swift
//  GymNote
//
//  Created by Rafał Swat on 18/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var session: FireBaseSession
    @State var showAlert = false
    var profile: UserProfile
    
    var body: some View {
        ZStack {
        List {
            VStack {
                HStack {
                    Spacer()
                    CircleImage(image: Image(uiImage: profile.userImage))
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
            
            if self.showAlert {
                WarningAlert(showAlert: self.$showAlert,
                             title: "Warninig",
                             message: "",//self.session.errorDiscription!,
                             buttonTitle: "ok")
            }
    }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    
    static var prevProfile = UserProfile()
    
    static var previews: some View {
        NavigationView {
            ProfileView(profile: prevProfile).environmentObject(FireBaseSession())
        }
    }
}
