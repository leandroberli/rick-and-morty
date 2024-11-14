//
//  CharacterListView.swift
//  RickAndMorty
//
//  Created by Leandro Berli on 13/11/2024.
//

import SwiftUI

struct CharacterGridView<Item: View, DetailDestination: View>: View {
    var columns: [GridItem] {
        [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
    }
    
    var itemWidth: CGFloat {
        UIScreen.main.bounds.width / 2 - 16
    }
    
    var itemHeight: CGFloat {
        (UIScreen.main.bounds.height - 44 - 20) / 3.5
    }
    
    var characters: [FavoritableCharacter]
    
    let item: (FavoritableCharacter) -> Item
    
    let navigationLinkDestination: (FavoritableCharacter) -> DetailDestination
    
    let tryFetchNextPage: () -> Void
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(characters, id: \.self) { character in
                NavigationLink(destination: navigationLinkDestination(character), label: {
                    item(character)
                        .onAppear {
                            if character.data.id == characters.last?.data.id {
                                tryFetchNextPage()
                            }
                        }
                })
                .buttonStyle(.plain)
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .cornerRadius(8)
            }
        }
        .padding([.leading, .bottom, .trailing])
    }
}
