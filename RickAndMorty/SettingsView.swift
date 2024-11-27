//
//  SettingsView.swift
//  RickAndMorty
//
//  Created by Leandro Berli on 14/11/2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        ZStack(alignment: .bottom) {
            List {
                HStack {
                    Text("Dark mode")
                    Toggle("", isOn: $settings.isDarkMode)
                        .onChange(of: settings.isDarkMode) {
                            UserDefaults.standard.set(settings.isDarkMode, forKey: "isDarkMode")
                        }
                        .tint(Color(uiColor: UIColor.customPrimary200))
                }
            }
            .scrollDisabled(true)
            Text("Developed by Leandro Berli.\nPowered by https://rickandmortyapi.com/\nv\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")(\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""))")
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(.secondary)
                .padding()
            
        }
        
       
        .navigationTitle("Settings")
    }
}
