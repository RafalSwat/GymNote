//
//  ProfileButton.swift
//  GymNote
//
//  Created by Rafał Swat on 18/02/2021.
//  Copyright © 2021 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ProfileButton: View {
    
    @EnvironmentObject var session: FireBaseSession
    @Binding var showProfile: Bool
    @Binding var goToSignIn: Bool
    
    var body: some View {
        
        Button(action: {
            
            if self.session.userSession?.userProfile.isUserAnonymous == true {
                self.goToSignIn.toggle()
            } else {
                self.showProfile.toggle()
            }

        }, label: {
            
            if self.session.userSession?.userProfile.isUserAnonymous == true {
                Text("SignUp")
            } else {
                VStack {
                    Image(systemName: "person.crop.square")
                        .font(.title)
                }
            }
        })
        
            
        
    }
}

struct ProfileButton_Previews: PreviewProvider {
    
    @State static var show = false
    @State static var go = false
    static var previews: some View {
        ProfileButton(showProfile: $show, goToSignIn: $go)
    }
}
