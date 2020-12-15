//
//  ProfileView.swift
//  GymNote
//
//  Created by Rafał Swat on 18/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var session: FireBaseSession
    @State var showAlert = false
    var profile: UserProfile
    
    var lightColorSet = [Color(UIColor.systemBackground), .customLight, Color(UIColor.systemBackground)]
    var darkColorSet = [Color(UIColor.secondarySystemBackground), .customLight, Color(UIColor.secondarySystemBackground)]
    
    var body: some View {
        ZStack {
        List {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(LinearGradient(gradient: Gradient(colors: colorScheme == .light ? lightColorSet : darkColorSet), startPoint: .leading, endPoint: .trailing))
            VStack {
                HStack {
                    Spacer()
                    RectangularImge(image: Image(uiImage: profile.userImage))
                        .padding(.top, 20)
                        .padding(.bottom, 15)
                    Spacer()
                }
                Text("\(profile.userName) \(profile.userSurname)")
                    .font(Font.largeTitle.weight(.bold))
                    .foregroundColor(colorScheme == .light ? .white : .black)
                    .shadow(color: colorScheme == .light ? .black : .white, radius: 3)
                    .padding(.bottom, 15)
            }
            }
            Section(header: Text("Basic info")) {
                
                HStack {
                    Text("Email:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .shadow(color: .customShadow, radius: 1)
                    Spacer()
                    Text(profile.userEmail)
                        .font(.headline)
                        .foregroundColor(colorScheme == .light ? .black : .white)
                        .shadow(color: colorScheme == .light ? .white : .black, radius: 3)
                }
                .padding(.vertical, 6)
                .background(LinearGradient(gradient: Gradient(colors: colorScheme == .light ? lightColorSet : darkColorSet), startPoint: .leading, endPoint: .trailing))
                
                
                HStack {
                    Text("Height:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .shadow(color: .customShadow, radius: 1)
                    Spacer()
                    Text("\(profile.userHeight) cm")
                        .font(.headline)
                        .foregroundColor(colorScheme == .light ? .black : .white)
                        .shadow(color: colorScheme == .light ? .white : .black, radius: 3)
                }
                .padding(.vertical, 6)
                .background(LinearGradient(gradient: Gradient(colors: colorScheme == .light ? lightColorSet : darkColorSet), startPoint: .leading, endPoint: .trailing))
                
                HStack {
                    Text("Gender:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .shadow(color: .customShadow, radius: 1)
                    Spacer()
                    Text(profile.userGender)
                        .font(.headline)
                        .foregroundColor(colorScheme == .light ? .black : .white)
                        .shadow(color: colorScheme == .light ? .white : .black, radius: 3)
                }
                .padding(.vertical, 6)
                .background(LinearGradient(gradient: Gradient(colors: colorScheme == .light ? lightColorSet : darkColorSet), startPoint: .leading, endPoint: .trailing))
                
                HStack {
                    Text("Date of birth:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .shadow(color: .customShadow, radius: 1)
                    Spacer()
                    Text("\(DateConverter.dateFormat.string(from: profile.userDateOfBirth))")
                        .font(.headline)
                        .foregroundColor(colorScheme == .light ? .black : .white)
                        .shadow(color: colorScheme == .light ? .white : .black, radius: 3)
                }
                .padding(.vertical, 6)
                .background(LinearGradient(gradient: Gradient(colors: colorScheme == .light ? lightColorSet : darkColorSet), startPoint: .leading, endPoint: .trailing))
            }
            
            
            Section(header: Text("Training level")) {
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(LinearGradient(gradient: Gradient(colors: colorScheme == .light ? lightColorSet : darkColorSet), startPoint: .leading, endPoint: .trailing))
                HStack {
                    Spacer()
                    Text("beginner")
                        .font(Font.title.weight(.bold))
                        .foregroundColor(colorScheme == .light ? .white : .black)
                        .shadow(color: colorScheme == .light ? .black : .white, radius: 3)
                        .padding(.vertical, 5)
                    Spacer()
                }
                }
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
