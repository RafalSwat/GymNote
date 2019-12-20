//
//  ProfileButton.swift
//  GymNote
//
//  Created by Rafał Swat on 20/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ProfileButton: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var profilesButtonImage: Image = Image(systemName: "person.circle")
    var profile: UserProfile

    var body: some View {
    
        NavigationLink(destination: ProfileView(profile: profile)) {
            self.profilesButtonImage
                .font(.largeTitle)
                .foregroundColor(
                    colorScheme == .light ? .black : .secondary
            )
        }
    }
}

struct ProfileButton_Previews: PreviewProvider {
    static var previews: some View {
        ProfileButton(profile: UserProfile.default)
    }
}
