//
//  ProfileView.swift
//  GymNote
//
//  Created by Rafał Swat on 18/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack {
                CircleImage(image: Image("staticImage"))
                    .padding()
                List {
                    ForEach(0 ..< 5) { number in
                        Text("Row \(number)")
                    }
                }.navigationBarTitle("Profile", displayMode: .inline)
            }
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
