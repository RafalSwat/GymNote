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
    
    var body: some View {
        VStack {
            AddButton(addButtonText: "create new program",
                      action: {print("AddButton in ChooseProramView tapped!")}, addingMode: self.$passageCreateProgram)
                .padding()
        }
        .navigationBarTitle("Choose Program", displayMode: .inline)
    }
}

struct ChooseProgramView_Previews: PreviewProvider {
    
    @State static var session = FireBaseSession()
    
    static var previews: some View {
        NavigationView {
            ChooseProgramView().environmentObject(session)
        }
    }
}
