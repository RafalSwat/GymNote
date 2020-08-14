//
//  ArrayQuery.swift
//  GymNote
//
//  Created by Rafał Swat on 13/08/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import Foundation
import SwiftUI

class ArrayQuery {
    
    
    func closestValue(array: [CGFloat], target: CGFloat) -> CGFloat {
        // Array must not be empty
        guard array.count > 0 else { fatalError("Array must not be empty") }

        // If array has only 1 element, that element is the closest
        guard array.count > 1 else { return array[0] }

        // To use binary search, your array must be ever-increasing or ever-decreasing
        // Here, we require that the array must be ever-increasing
        for index in 1..<array.count {
            if array[index - 1] > array[index] {
                fatalError("Array must be monotonous increasing. Did you forget to sort it?")
            }
        }

        // If the target is outside of the range of the array,
        // return the edges of the array
        guard array.first! <= target else { return array.first! }
        guard target <= array.last! else { return array.last! }

        // Now some actual searching
        var left = 0
        var right = array.count - 1

        while left < right {
            if left == right - 1 {
                return abs(array[left] - target) <= abs(array[right] - target) ? array[left] : array[right]
            }

            let middle = (left + right) / 2
            switch array[middle] {
            case target:
                return target
            case ..<target:
                left = middle
            default:
                right = middle
            }
        }

        fatalError("It should never come here")
    }
}
