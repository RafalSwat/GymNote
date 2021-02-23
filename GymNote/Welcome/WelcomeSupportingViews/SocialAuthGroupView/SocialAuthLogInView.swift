//
//  SocialAuthLogInView.swift
//  GymNote
//
//  Created by Rafał Swat on 23/02/2021.
//  Copyright © 2021 Rafał Swat. All rights reserved.
//

import SwiftUI

struct SocialAuthLogInView: View {
    var body: some View {
        VStack {
            Text("----- or continue with -----")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 40)
            
            HStack {
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.blendingInWithTheList, colorScheme == .light ? .customLight : .customDark]),
                                             startPoint: .bottomLeading, endPoint: .topTrailing))
                        .frame(minWidth: 40,
                               maxWidth: 50,
                               minHeight: 40,
                               maxHeight: 50,
                               alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(5)
                        .shadow(color: Color.customShadow, radius: 4, x: -3, y: 3)
                        .overlay(Image(systemName: "applelogo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(colorScheme == .light ? .black : .white)
                                    .padding(7))
                }
                Spacer()
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.blendingInWithTheList, colorScheme == .light ? .customLight : .customDark]),
                                             startPoint: .topTrailing, endPoint: .bottomLeading))
                        .frame(minWidth: 40,
                               maxWidth: 50,
                               minHeight: 40,
                               maxHeight: 50,
                               alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(5)
                        .shadow(color: Color.customShadow, radius: 4, x: -3, y: 3)
                        .overlay(Image("googleImage")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(7))
                }
                Spacer()
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.blendingInWithTheList, colorScheme == .light ? .customLight : .customDark]),
                                             startPoint: .bottomLeading, endPoint: .topTrailing))
                        .frame(minWidth: 40,
                               maxWidth: 50,
                               minHeight: 40,
                               maxHeight: 50,
                               alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(5)
                        .shadow(color: Color.customShadow, radius: 4, x: -3, y: 3)
                        .overlay(Image("facebookImage")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(7))
                }
                Spacer()
                
            }
        }
    }
}

struct SocialAuthLogInView_Previews: PreviewProvider {
    static var previews: some View {
        SocialAuthLogInView()
    }
}
