//
//  NavigationCoordinator.swift
//  Weather App
//
//  Created by Ron Jurincie on 9/24/24.
//

import Foundation
import SwiftUI

final class NavigationCoordinator {
    static let shared = NavigationCoordinator()
    
    func getMainView() -> MainView {
        return MainView()
    }
    
    func getSettingsView() -> SettingsView {
        return SettingsView()
    }
}
