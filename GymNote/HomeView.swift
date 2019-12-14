//
//  HomeView.swift
//  GymNote
//
//  Created by Rafał Swat on 06/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    
                    CircleImage(image: Image("staticImage"))
                    
                    VStack {
                        Text("Jan Kowalski")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("22.11.2019")
                        Divider()
                        Text("Last training:")
                        Text("20.11.2019")
                    }
                }.padding(.horizontal)
                
                Button("note training", action:{})
                    .frame(minWidth: CGFloat(0), maxWidth: .infinity)
                    .border(Color.gray, width: CGFloat(2))
                    .cornerRadius(CGFloat(5))
                    .font(.headline)
                    .padding()
                
                Button("note body measurments", action:{})
                    .frame(minWidth: CGFloat(0), maxWidth: .infinity)
                    .border(Color.gray, width: CGFloat(2))
                    .cornerRadius(CGFloat(5))
                    .font(.headline)
                    .padding()

                
                Button("show stats", action:{})
                    .frame(minWidth: CGFloat(0), maxWidth: .infinity)
                    .border(Color.gray, width: CGFloat(2))
                    .cornerRadius(CGFloat(5))
                    .font(.headline)
                    .padding()

            }.navigationBarTitle("Home")
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
