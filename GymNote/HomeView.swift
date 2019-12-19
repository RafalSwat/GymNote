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
    
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    let dataString = dateFormat.string(from: Date())
    
    var body: some View {
        NavigationView {
            VStack {
                
                TitleBelt(title: authSession.session!.userName, subtitle: dataString)
                
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

