//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Leandro Berli on 25/10/2024.
//

import SwiftUI

class Settings: ObservableObject {
    @Published var isDarkMode: Bool = UserDefaults.standard.bool(forKey: "isDarkMode")
}

struct ContentView: View {
    @StateObject var settings: Settings = Settings()
    
    var body: some View {
        TabView {
            AllCharactersListView()
                .tabItem {
                    Label("All", systemImage: "person")
            }
            
            FavoritesView()
                .tabItem {
                        Label("Favs", systemImage: "heart")
            }
        }
        .accentColor(Color(uiColor: .label))
        .environment(\.colorScheme, settings.isDarkMode ? .dark : .light)
        .environmentObject(settings)
    }
}

#Preview {
    ContentView()
}
