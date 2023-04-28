//
//  EnvironmentKeys.swift
//  project400
//
//  Created by Omar Alshuaili on 27/04/2023.
//

import Foundation
import SwiftUI

struct BottomBarVisibleKey: EnvironmentKey {
    static let defaultValue: Bool = true
}

extension EnvironmentValues {
    var isBottomBarVisible: Bool {
        get { self[BottomBarVisibleKey.self] }
        set { self[BottomBarVisibleKey.self] = newValue }
    }
}
