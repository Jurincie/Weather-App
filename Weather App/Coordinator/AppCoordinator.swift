//
//  AppCoordinator.swift
//  Weather App
//
//  Created by Ron Jurincie on 9/19/24.
//

import Foundation
import SwiftUI
import SwiftData

enum Screen: Identifiable, Hashable {
    case mainView
    case settingsView
    var id: Self { return self }
}

protocol AppCoordinatorProtocol {
    var path: NavigationPath { get set }

    func push(_ screen:  Screen)
    func pop()
}

@Observable
class AppCoordinator: AppCoordinatorProtocol {
    
    var path: NavigationPath = NavigationPath()
    
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    func pop() {
        if path.count > 0 {
            path.removeLast()
        }
    }
    
    // MARK: - Presentation Style Providers
    @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
        case .mainView:
            MainView(locationSearchService: LocationSearchService())
        case .settingsView:
            SettingsView()
        }
    }
}
