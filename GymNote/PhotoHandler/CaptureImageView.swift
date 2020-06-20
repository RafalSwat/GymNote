//
//  CaptureImageView.swift
//  GymNote
//
//  Created by Rafał Swat on 13/02/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct CaptureImageView {
    
    @Binding var isShown: Bool
    @Binding var image: UIImage

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, image: $image)
    }
}

extension CaptureImageView: UIViewControllerRepresentable {
    
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker  
    }
    
    func updateUIViewController(
        _ uiViewController: UIImagePickerController,
        context: UIViewControllerRepresentableContext<CaptureImageView>) {
        
    }
}
