//
//  RAMCHaractersListView.swift
//  RickAndMorty
//
//  Created by Leandro Berli on 25/10/2024.
//

import SwiftUI

struct AllCharactersListView: View {
    @StateObject var viewModel: AllCharactersListViewModel = AllCharactersListViewModel()
    @State var searchText: String = ""
    
    var body: some View {
        allCharactersView
    }
    
    private var noSearchResultsView: some View {
        VStack {
            Text("There is no results for the given name")
                .font(.system(size: 14, weight: .regular))
                .padding(.top, 32)
        }
    }
    
    private var allCharactersView: some View {
        NavigationView {
            ScrollView {
                if !viewModel.noSearchResults {
                    CharacterGridView(characters: viewModel.characters, item: { char in
                        FavoritableCharacterItemView(character: char,
                                                     toggleFavoriteAction: { char in
                            viewModel.toggleFavorite(character: char.data)
                        })
                    }, navigationLinkDestination: { character in
                        if let index = viewModel.characters.firstIndex(of: character) {
                            return RAMCharacterDetailView(character: $viewModel.characters[index])
                        } else {
                            return RAMCharacterDetailView(character: .constant(FavoritableCharacter.placeholder))
                        }
                    }, tryFetchNextPage: {
                        viewModel.setNextCharactersPageIfExists()
                    })
                } else {
                    noSearchResultsView
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: { SettingsView() }, label: {
                        Image(systemName: "gearshape.fill")
                    })
                }
            }
            .navigationTitle("Characters")
            .searchable(text: $viewModel.searchString , prompt: Text("Type name"))
        }
        .onAppear {
            viewModel.setCharactersFirstPage()
        }
    }
}

