//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Leandro Berli on 25/10/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        RAMCHaractersListView()
            .environment(\.colorScheme, .dark)
    }
}

#Preview {
    ContentView()
}
