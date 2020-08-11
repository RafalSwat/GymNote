//
//  CustomTextField.swift
//  GymNote
//
//  Created by Rafał Swat on 25/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct NumberTextField: UIViewRepresentable {
    
    @Binding var text: String
    var keyType: UIKeyboardType
    var placeHolder: String
    
    func makeUIView(context: Context) -> UITextField {
        let textfield = UITextField()
        textfield.keyboardType = keyType
        textfield.placeholder = placeHolder
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0,
                                              width: textfield.frame.size.width,
                                              height: 44))
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .done,
                                         target: self,
                                         action: #selector(textfield.doneButtonTapped(button:)))
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                    target: nil,action: nil)
        toolBar.setItems([space, doneButton], animated: true)
        toolBar.tintColor = .orange
        textfield.inputAccessoryView = toolBar
        return textfield
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
}


// MARK: extension for done button
extension  UITextField {
    @objc func doneButtonTapped(button: UIBarButtonItem) {
        self.resignFirstResponder()
    }
}
// MARK: extension for keyboard to dismiss
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

