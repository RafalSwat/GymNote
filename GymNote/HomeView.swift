//
//  HomeView.swift
//  GymNote
//
//  Created by Rafał Swat on 06/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var authSession: AuthSessionStore
    
    var body: some View {
        NavigationView {
            VStack {
                
                TitleBelt(title: authSession.session!.userName, subtitle: authSession.session!.userEmail)
                
                Button("note training", action:{})
                    .buttonStyle(RectangularButtonStyle())
                    .padding()
                
                Button("note body measurments", action:{})
                    .buttonStyle(RectangularButtonStyle())
                    .padding()

                
                Button("show stats", action:{})
                    .buttonStyle(RectangularButtonStyle())
                    .padding()

            }.navigationBarTitle("Home", displayMode: .inline)


            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    
    @State static var authSession = AuthSessionStore()
    
    static var previews: some View {
        HomeView()
            .environmentObject(authSession)
    }

}

