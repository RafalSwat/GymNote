//
//  UserData.swift
//  GymNote
//
//  Created by Rafał Swat on 04/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import Foundation
import SwiftUI

final class UserData: ObservableObject {
    @Published var userProfileData = UserProfile.default
}
