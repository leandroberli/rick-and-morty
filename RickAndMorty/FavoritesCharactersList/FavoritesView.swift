//
//  FavoritesView.swift
//  RickAndMorty
//
//  Created by Leandro Berli on 13/11/2024.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject var viewModel: FavoritesCharactersListViewModel = FavoritesCharactersListViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.characters.isEmpty {
                    Text("You don't have any favorite characters yet.")
                } else {
                    CharacterGridView(characters: viewModel.characters, item: { char in
                        FavoritableCharacterItemView(character: char, toggleFavoriteAction: { char in
                            viewModel.toggleFavorite(character: char)
                        })
                    }, navigationLinkDestination: { char in
                        if let index = viewModel.characters.firstIndex(of: char) {
                            RAMCharacterDetailView(character: $viewModel.characters[index])
                        } else {
                            RAMCharacterDetailView(character: .constant(FavoritableCharacter.placeholder))
                        }
                    }, tryFetchNextPage: { })
                }
                
            }
            .navigationTitle("Favorites")
        }
        .onAppear {
            viewModel.setFavoritesCharacters()
        }
    }
}

