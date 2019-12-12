//
//  KeyboardHost.swift
//  GymNote
//
//  Created by Rafał Swat on 11/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//
import SwiftUI

struct KeyboardHost<Content: View>: View {
    let view: Content

    @State private var keyboardHeight: CGFloat = 0

    private let showPublisher = NotificationCenter.Publisher.init(
        center: .default,
        name: UIResponder.keyboardWillShowNotification
    ).map { (notification) -> CGFloat in
        if let rect = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect {
            return rect.size.height
        } else {
            return 0
        }
    }

    private let hidePublisher = NotificationCenter.Publisher.init(
        center: .default,
        name: UIResponder.keyboardWillHideNotification
    ).map {_ -> CGFloat in 0}

    // Like HStack or VStack, the only parameter is the view that this view should layout.
    // (It takes one view rather than the multiple views that Stacks can take)
    init(@ViewBuilder content: () -> Content) {
        view = content()
    }
    
    var body: some View {
        VStack {
            view
                .padding(.bottom, keyboardHeight)
                .animation(.default)
        }.onReceive(showPublisher.merge(with: hidePublisher)) {
            (height) in self.keyboardHeight = height + 100
        }
    }
}


