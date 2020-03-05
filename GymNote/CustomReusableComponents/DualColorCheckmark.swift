//
//  DualColorCheckmark.swift
//  GymNote
//
//  Created by Rafał Swat on 05/03/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct DualColorCheckmark: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var checkmarkImage = Image(systemName: "checkmark")
    
    var body: some View {
        checkmarkImage
            .foregroundColor(colorScheme == .light ? .black : .secondary)
            .font(.headline)
    }
}

struct DualColorCheckmark_Previews: PreviewProvider {
    static var previews: some View {
        DualColorCheckmark()
    }
}
