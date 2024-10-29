//
//  RAMCHaractersListView.swift
//  RickAndMorty
//
//  Created by Leandro Berli on 25/10/2024.
//

import SwiftUI

struct RAMCHaractersListView: View {
    @StateObject var viewModel: RAMCharactersListViewModel = RAMCharactersListViewModel()
    @State var searchText: String = ""
    
    var columns: [GridItem] {
        [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
    }
    
    var itemWidth: CGFloat {
        UIScreen.main.bounds.width / 2 - 16
    }
    
    var itemHeight: CGFloat {
        (UIScreen.main.bounds.height - 44 - 20) / 3.5
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                if !viewModel.noSearchResults {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(viewModel.characters, id: \.self) { character in
                            NavigationLink(destination: {
                                //TODO: See how to improve this initialization
                                if let charIndex = viewModel.characters.firstIndex(of: character) {
                                    RAMCharacterDetailView(character: $viewModel.characters[charIndex])
                                }
                            }, label: {
                                characterGridItemView(character: character.data)
                                    .onAppear {
                                        if character.data.id == viewModel.characters.last?.data.id {
                                            viewModel.setNextCharactersPageIfExists()
                                        }
                                    }
                            })
                            .buttonStyle(.plain)
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .cornerRadius(8)
                        }
                    }
                    .padding([.leading, .bottom, .trailing])
                } else {
                    noSearchResultsView
                }
            }
            .navigationTitle("Characters")
            .searchable(text: $viewModel.searchString , prompt: Text("Type name"))
        }
        .onAppear {
            viewModel.setCharactersFirstPage()
        }
        .accentColor(Color(uiColor: .label))
    }
    
    private func characterGridItemView(character: Character) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            AsyncCachedImage(url: URL(string: character.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image(systemName: "photo")
                    .imageScale(.large)
                    .frame(width: 110, height: 110)
            }
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center) {
                    Text(character.name)
                        .font(.system(size: 16, weight: .semibold))
                        .lineLimit(2)
                    Spacer()
                    Button(action: {
                        viewModel.toggleFavorite(character: character)
                    }, label: {
                        UserDefaults.standard.bool(forKey: "\(character.id)") ? Image(systemName: "heart.fill") : Image(systemName: "heart")
                    })
                    .tint(.green)
                }
            }
            .padding([.leading, .trailing], 8)
            .padding(.bottom, 12)
        }
        .frame(width: itemWidth, height: itemHeight)
        .clipped()
    }
    
    private var noSearchResultsView: some View {
        VStack {
            Text("There is no results for the given name")
                .font(.system(size: 14, weight: .regular))
                .padding(.top, 32)
        }
    }
}
