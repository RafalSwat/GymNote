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
    
    var addBarItemImage: Image = Image(systemName: "plus.circle")

    var body: some View {
    
        Button(action: {
            self.showAddView = true
        }) {
            self.addBarItemImage
                .font(.largeTitle)
                .foregroundColor(colorScheme == .light ? .black : .secondary)
        }
    }
}

struct AddBarItem_Previews: PreviewProvider {
    
    @State static var prevShowAddView = false
    
    static var previews: some View {
        AddBarItem(showAddView: $prevShowAddView)
    }
}
