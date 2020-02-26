//
//  HomeView.swift
//  GymNote
//
//  Created by Rafał Swat on 06/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var session: FireBaseSession

    let dataString = DateConverter.dateFormat.string(from: Date())
    
    var body: some View {
        VStack {
            
            TitleBelt(title: session.userSession?.userName ?? "", subtitle: dataString)
            
            
            Group {
                Button("note training", action:{})
                    .buttonStyle(RectangularButtonStyle())
                    .padding()
                
                Button("note body measurments", action:{})
                    .buttonStyle(RectangularButtonStyle())
                    .padding()
                
                
                Button("show stats", action:{})
                    .buttonStyle(RectangularButtonStyle())
                    .padding()
            }
            
        }
        .navigationBarTitle("Home", displayMode: .inline)
        .navigationBarItems(
            leading: BackButton(),
            trailing: ProfileButton(profile: session.userSession ?? UserProfile.default)
        )
        .onAppear(perform: getUser)
    }
    
    //MARK: Functions
    func getUser() {
        session.listen()
    }
}

struct HomeView_Previews: PreviewProvider {
    
    @State static var session = FireBaseSession()
    
    static var previews: some View {
        NavigationView {
            HomeView()
                .environmentObject(session)
        }
    }

}

