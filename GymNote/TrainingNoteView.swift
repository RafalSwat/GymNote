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
    @State private var passageTrainingSession = false
    @State private var passageCreateProgram = false
    @State private var passageChooseProgram = false
    
    var body: some View {
        VStack {
            
            Image("staticImage")
                .resizable()
                .frame(height: UIScreen.main.bounds.height/2.8)
                .scaledToFill()
                .padding(30)
            
            NavigationLink(destination: TrainingSessionView(),
                           isActive: self.$passageTrainingSession) { Text("") }
            
            NavigationLink(destination: CreateProgramView(),
                           isActive: self.$passageCreateProgram) { Text("") }
            
            NavigationLink(destination: ChooseProgramView(listOfTrainings: session.userSession?.userTrainings.listOfTrainings ?? [Training]()),
                           isActive: self.$passageChooseProgram) { Text("") }
            
            Group {
                Button("add session", action:{ self.passageTrainingSession.toggle()})
                    .buttonStyle(RectangularButtonStyle())
                    .padding()
                
                Button("create program", action:{self.passageCreateProgram.toggle()})
                    .buttonStyle(RectangularButtonStyle())
                    .padding()
                
                
                Button("choose program", action:{
                    self.passageChooseProgram.toggle()})
                    .buttonStyle(RectangularButtonStyle())
                    .padding()
            }
        }
        .navigationBarTitle("Training Note", displayMode: .inline)
        .navigationBarItems(
            leading: BackButton(),
            trailing: ProfileButton(profile: session.userSession?.userProfile ?? UserProfile())
        )
//        .onAppear {
//            // canvas can not work with this method,
//            //it can`t display sth that could be nil! (it works only on simulator or device)
//            self.session.uploadTrainings(userTrainings: (self.session.userSession?.userTrainings)!)
//            
//        }
    }
    
}

struct TrainingNoteView_Previews: PreviewProvider {
    
    @State static var session = FireBaseSession()
    
    static var previews: some View {
        TrainingNoteView()
            .environmentObject(session)
    }
}
