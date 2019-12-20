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
        VStack {
            CircleImage(image: profile.userImage)
                .padding()
            List {
                Text(profile.userName)
                Text(profile.userSurname)
                Text(profile.userEmail)
                //Text("\(profile.userGender)")
                Text("\(profile.userHeight)")
            }
            .navigationBarTitle("Profile", displayMode: .inline)
            .navigationBarItems(leading: BackButton())
            
        }
        
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(profile: UserProfile.default)
    }
}
