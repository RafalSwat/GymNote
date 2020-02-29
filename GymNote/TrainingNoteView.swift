//
//  TrainingNoteView.swift
//  GymNote
//
//  Created by Rafał Swat on 28/02/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct TrainingNoteView: View {
    @EnvironmentObject var session: FireBaseSession
    
    var body: some View {
        VStack {
            
            Image("staticImage")
                .resizable()
                .frame(height: UIScreen.main.bounds.height/2.8)
                .scaledToFill()
                .padding(30)
            
            Group {
                Button("add session", action:{})
                    .buttonStyle(RectangularButtonStyle())
                    .padding()
                
                Button("create program", action:{})
                    .buttonStyle(RectangularButtonStyle())
                    .padding()
                
                
                Button("choose program", action:{})
                    .buttonStyle(RectangularButtonStyle())
                    .padding()
            }
        }
        .navigationBarTitle("Training Note", displayMode: .inline)
        .navigationBarItems(
            leading: BackButton(),
            trailing: ProfileButton(profile: session.userSession ?? UserProfile.default)
        )
    }
    
}

struct TrainingNoteView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingNoteView()
            .environmentObject(FireBaseSession())
    }
}
