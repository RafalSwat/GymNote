//
//  AddBarItem.swift
//  GymNote
//
//  Created by Rafał Swat on 05/03/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct AddBarItem: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.presentationMode) var presentationMode
    @Binding var showAddView: Bool
    
    var addBarItemImage: Image = Image(systemName: "plus.square")
    
    var body: some View {
        
        Button(action: { withAnimation { self.showAddView = true }}) {
            self.addBarItemImage
                .font(.title)
                .foregroundColor(Color.orange)
        }
    }
}

struct AddBarItem_Previews: PreviewProvider {
    
    @State static var prevShowAddView = false
    
    static var previews: some View {
        AddBarItem(showAddView: $prevShowAddView)
    }
}
