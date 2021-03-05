//
//  DocRectangle.swift
//  GymNote
//
//  Created by Rafał Swat on 02/03/2021.
//  Copyright © 2021 Rafał Swat. All rights reserved.
//

import Foundation
import SwiftUI

struct DocRectangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX*0.6, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY*0.35))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))

        return path
    }
}

struct DocTraingle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.maxX*0.6, y: rect.minY+1))
        path.addCurve(to: CGPoint(x: rect.maxX-1, y: rect.maxY*0.35), control1: CGPoint(x: rect.maxX*0.6, y: rect.maxY*0.35), control2: CGPoint(x: 0.6*rect.maxX, y: 0.35*rect.maxY))

        return path
    }
}

struct RegularRectangle: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))

        return path
    }
    
}
