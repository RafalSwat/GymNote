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
    @State var listOfTrainings: [Training]
    
    var body: some View {
        VStack {
            List {
                ForEach(listOfTrainings, id: \.trainingID) { training in
                    Text(training.trainingName)
                }
            }
            
            AddButton(addButtonText: "create new program",
                      action: {print("AddButton in ChooseProramView tapped!")},
                      addingMode: self.$passageCreateProgram)
                .padding()
        }
        .navigationBarTitle("Choose Program", displayMode: .inline)
    }
}

struct ChooseProgramView_Previews: PreviewProvider {
    
    @State static var prevSession = FireBaseSession()
    @State static var prevListOfTrainings = [Training(name: "My Training",
                                                      subscription: "My litte subscription",
                                                      date: "01-01-2020",
                                                      exercises: [Exercise(name: "My Exercise")])]
    
    static var previews: some View {
        NavigationView {
            ChooseProgramView(listOfTrainings: prevListOfTrainings).environmentObject(prevSession)
        }
    }
}
