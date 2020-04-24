//
//  TitleBelt.swift
//  GymNote
//
//  Created by Rafał Swat on 18/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import SwiftUI

struct TitleBelt: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Binding var title: String 
    @Binding var subtitle: String
    @Binding var editMode: Bool
    @Binding var image: Image  // = Image("staticImage")
    var lightBeltColors: [Color] = [.white, .yellow, .red]
    var darkBeltColors: [Color] = [.black, .orange, .red]
    
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(
                        colors: colorScheme == .light ? lightBeltColors : darkBeltColors),
                    startPoint: .leading, endPoint: .trailing))
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/5, alignment: .trailing)
                .overlay(CircleImage(image: image), alignment: .leading)
            
            VStack(alignment: .center) {
                if editMode {
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: UIScreen.main.bounds.width/2,
                               height: UIScreen.main.bounds.height/12,
                               alignment: .center)
                        .font(.title)
                        .overlay(TextField("...", text: $title)
                            .lineLimit(nil)
                            .multilineTextAlignment(.center)
                            
                            
                    )
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: UIScreen.main.bounds.width/2,
                               height: UIScreen.main.bounds.height/15,
                               alignment: .center)
                        .font(.subheadline)
                        .overlay(TextField("...", text: $subtitle)
                            .lineLimit(nil)
                            .multilineTextAlignment(.center)
                            
                    )
                    
                } else {
                    Text(title)
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.main.bounds.width/2,
                               height: UIScreen.main.bounds.height/12,
                               alignment: .center)
                        .font(.title)
                    
                    Text(subtitle)
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.main.bounds.width/2,
                               height: UIScreen.main.bounds.height/12,
                               alignment: .center)
                        .font(.subheadline)
                }
            }.offset(x: UIScreen.main.bounds.width/4)
        }.padding(.bottom, 25)
    }
}

struct TitleBelt_Previews: PreviewProvider {
    
    @State static var prevTitle = "GYMNOTE"
    @State static var prevSubtitle = "..."
    @State static var prevEditMode = true
    @State static var prevImage  = Image("staticImage")
    
    static var previews: some View {
        TitleBelt(title: $prevTitle, subtitle: $prevSubtitle, editMode: $prevEditMode, image: $prevImage)
    }
}
