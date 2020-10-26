//
//  EditTrainingListOptions.swift
//  GymNote
//
//  Created by Rafał Swat on 26/10/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct EditTrainingListOptions: View {
    
    @Binding var editMode: EditMode
    @Binding var deleteMode: Bool
    
    var body: some View {
        HStack {
            Button(action: {
                if self.editMode == .inactive {
                    self.editMode = .active
                    self.deleteMode = false
                } else {
                    self.editMode = .inactive
                }
            }, label: {
                if self.editMode == .inactive {
                    Image(systemName: "list.number")
                        .padding(.horizontal, 23)
                    
                } else {
                    Image(systemName: "checkmark.square")
                        .padding(.horizontal, 23)
                }
                
            })
            Button(action: {
                if self.deleteMode == false {
                    self.deleteMode = true
                    self.editMode = .inactive
                } else {
                    self.deleteMode = false
                }
            }, label: {
                if deleteMode {
                    Image(systemName: "trash.slash")
                } else {
                    Image(systemName: "trash")
                }
            })
        }
        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
        .padding(.bottom, 10)
    }
}

struct EditTrainingListOptions_Previews: PreviewProvider {
    
    @State static var prevEditMode = EditMode.inactive
    @State static var prevDeleteMode = false
    
    static var previews: some View {
        EditTrainingListOptions(editMode: $prevEditMode, deleteMode: $prevDeleteMode)
    }
}
