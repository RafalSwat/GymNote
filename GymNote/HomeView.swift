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
                HStack {
                    
                    CircleImage(image: Image("staticImage"))
                    
                    VStack {
                        //Text("Jan Kowalski")
                        Text("\(authSession.session!.userEmail)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(3)
                        Text("22.11.2019")
                        Divider()
                        Text("Last training:")
                        Text("20.11.2019")
                    }
                }.padding(.horizontal)
                
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



