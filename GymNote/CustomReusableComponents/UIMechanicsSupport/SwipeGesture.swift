//
//  SwipeGesture.swift
//  GymNote
//
//  Created by Rafał Swat on 16/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct SwipeGesture:  ViewModifier {
    
    enum Direction {
        case vertical
        case horizontal
    }
    
    let direction: Direction
    let thirdScreenWidth = UIScreen.main.bounds.width/3
    let thirdScreenheight = UIScreen.main.bounds.height/3
    
    @State private var draggedOffset: CGSize = .zero
    @Binding var showContetnt: Bool
    
    func body(content: Content) -> some View {
        content
            .offset(
                CGSize(width: direction == .vertical ? 0 : draggedOffset.width,
                       height: direction == .horizontal ? 0 : draggedOffset.height))
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.width < 0 {
                            self.draggedOffset = value.translation
                        } else {
                            self.draggedOffset = .zero
                        }
                }
                .onEnded { value in
                    withAnimation(.spring()) {
                        if value.translation.width < 0 {
                            if value.translation.width < -(self.thirdScreenWidth) {
                                self.draggedOffset = CGSize(width: 0/*-(self.thirdScreenWidth)*/, height: value.translation.height)
                                self.showContetnt = true
                                
                            } else {
                                self.draggedOffset = .zero
                            }
                        } else {
                            self.draggedOffset = .zero
                            self.showContetnt = false} 
                        
                    }
                }
        )
    }
}
