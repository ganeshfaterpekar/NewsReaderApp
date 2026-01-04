//
//  NewsReaderAppApp.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 1/1/2026.
//

import SwiftUI

@main
struct NewsReaderApp: App {
    
    @Environment(\.appContainer) private var container
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.appContainer, container)
        }
    }
}

private struct AppContainerKey: EnvironmentKey {
    static let defaultValue: AppContainer = .live
}

extension EnvironmentValues {
    var appContainer: AppContainer {
        get { self[AppContainerKey.self] }
        set { self[AppContainerKey.self] = newValue }
    }
}



