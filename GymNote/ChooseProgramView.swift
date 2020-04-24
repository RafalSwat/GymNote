//
//  ChooseProgramView.swift
//  GymNote
//
//  Created by Rafał Swat on 07/04/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ChooseProgramView: View {
    
    @EnvironmentObject var session: FireBaseSession
    @State private var passageCreateProgram = false
    @State private var chooseProgramEdintMode = false
    @State var listOfTrainings: [Training]
    
    var body: some View {
        
        VStack {
            
            NavigationLink(destination: CreateProgramView(), isActive: self.$passageCreateProgram, label: { Text("") })
            
            Image("staticImage")
                .resizable()
                .frame(height: UIScreen.main.bounds.height/4)
                .aspectRatio(contentMode: .fit)
                .padding(15)
            
            List {
                ForEach(listOfTrainings, id: \.trainingID) { training in
                    
                    NavigationLink(destination: ProgramSessionView(program: training)) {
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text(training.trainingName)
                                    .font(.headline)
                            }
                            Text(training.trainingSubscription)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }.onDelete(perform: self.removeTraining)
            }
            
            AddButton(addButtonText: "create new program",
                      action: {print("AddButton in ChooseProramView tapped!")},
                      addingMode: self.$passageCreateProgram)
                .padding()
        }
        .navigationBarTitle("Choose Program", displayMode: .inline)
        .navigationBarItems(
            leading: BackButton(),
            trailing: CustomEditButton(editMode: self.$chooseProgramEdintMode)
        )
        
    }
    
    func removeTraining(at index: IndexSet) {
        
        index.sorted(by: > ).forEach { (i) in
            self.session.deleteTrainingFromFBR(userTrainings: (self.session.userSession?.userTrainings)!, training: listOfTrainings[i])
        }
        self.listOfTrainings.remove(atOffsets: index)
        
    }
}

struct ChooseProgramView_Previews: PreviewProvider {
    
    @State static var prevSession = FireBaseSession()
    @State static var prevListOfTrainings = [Training(id: UUID().uuidString,
                                                      name: "My Training",
                                                      subscription: "My litte subscription",
                                                      date: "01-Jan-2020",
                                                      exercises: [Exercise(name: "My Exercise")])]
    
    static var previews: some View {
        NavigationView {
            ChooseProgramView(listOfTrainings: prevListOfTrainings).environmentObject(prevSession)
        }
    }
}

