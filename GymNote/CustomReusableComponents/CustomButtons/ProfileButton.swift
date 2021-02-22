//
//  ProfileButton.swift
//  GymNote
//
//  Created by Rafał Swat on 18/02/2021.
//  Copyright © 2021 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ProfileButton: View {
    
    @Binding var showProfile: Bool
    
    var body: some View {
        
        Button(action: {
            self.showProfile.toggle()
        }, label: {
            VStack {
                Image(systemName: "person.crop.square")
                    .font(.title)
            }
        })
        
            
        
    }
}

struct ProfileButton_Previews: PreviewProvider {
    
    @State static var show = false
    static var previews: some View {
        ProfileButton(showProfile: $show)
    }
}
