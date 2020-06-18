//
//  ProgramSessionView.swift
//  GymNote
//
//  Created by Rafał Swat on 24/04/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ProgramSessionView: View {
    
    @EnvironmentObject var session: FireBaseSession
    var program: Training
    @State var programEditMode = false
    @State var programImage  = Image("staticImage")
    @State var programTitle = ""
    @State var programSubscription = ""
    
    var body: some View {
        ZStack {
            VStack {
                DateBelt()
                TitleBelt(title: $programTitle,
                          subtitle: $programSubscription,
                          CeditMode: $programEditMode,
                          image: $programImage)
                
                List(program.listOfExercises, id: \.self) { exercise in
                    ProgramSessionListRow(exercise: exercise)
                }
            }.onAppear {
                self.programTitle = self.program.trainingName
                self.programSubscription = self.program.trainingSubscription
            }
        }
    }
}

struct ProgramSessionView_Previews: PreviewProvider {
    
    @State static var prevSession = FireBaseSession()
    @State static var prevProgram = Training(id: UUID().uuidString,
                                             name: "My Program",
                                             subscription: "My litte subscription ",
                                             date: "01-Jan-2020",
                                             exercises: [Exercise(name: "My Exercise")])
    
    static var previews: some View {
        ProgramSessionView(program: prevProgram).environmentObject(prevSession)
    }
}
