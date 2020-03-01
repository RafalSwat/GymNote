//
//  TrainingSessionView.swift
//  GymNote
//
//  Created by Rafał Swat on 01/03/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct TrainingSessionView: View {
    
    @EnvironmentObject var session: FireBaseSession
    @State var addMode = false
    @State 
    
    var body: some View {
        
        VStack {
            DateBelt()
            TitleBelt(title: "...", subtitle: "...", editMode: true)
            Divider()
            Spacer()
            AddButton(addingMode: $addMode)
                .padding()
            
        }
        .navigationBarTitle("Training Note", displayMode: .inline)
        .navigationBarItems(
            leading: BackButton(),
            trailing: ProfileButton(profile: session.userSession ?? UserProfile.default)
        )
        
    }
}

struct TrainingSessionView_Previews: PreviewProvider {
    
    @State static var session = FireBaseSession()
    
    static var previews: some View {
        TrainingSessionView()
            .environmentObject(session)
    }
}
