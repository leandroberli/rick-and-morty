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
        .accentColor(Color(uiColor: UIColor.customPrimary))
        .environment(\.colorScheme, settings.isDarkMode ? .dark : .light)
        .environmentObject(settings)
    }
}

extension UINavigationController {

  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    navigationBar.topItem?.backButtonDisplayMode = .minimal
  }

}

extension UIColor {
    
    static var customPrimary: UIColor {
        return UIColor(hex: "#F27B35")
    }
    
    static var customPrimary2: UIColor {
        return UIColor(hex: "#F27B35")
    }
    
    convenience init(hex: String) {
            var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            hexSanitized = hexSanitized.hasPrefix("#") ? String(hexSanitized.dropFirst()) : hexSanitized

            var rgb: UInt64 = 0
            Scanner(string: hexSanitized).scanHexInt64(&rgb)

            let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgb & 0x0000FF) / 255.0
            self.init(red: red, green: green, blue: blue, alpha: 1.0)
        }
}

#Preview {
    ContentView()
}
