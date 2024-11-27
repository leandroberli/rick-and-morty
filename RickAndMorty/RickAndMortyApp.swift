//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Leandro Berli on 25/10/2024.
//

import SwiftUI

@main
struct RickAndMortyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    if ProcessInfo.processInfo.arguments.contains("UI-Testing") {
                        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                    }
                }
        }
    }
}
