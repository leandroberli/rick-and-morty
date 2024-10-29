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
                                RAMCharacterDetailView(character: character)
                            }, label: {
                                characterGridItemView(character: character)
                                    .onAppear {
                                        if character.id == viewModel.characters.last?.id {
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
        VStack(alignment: .leading, spacing: 8) {
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
                HStack {
                    Text(character.name)
                        .font(.system(size: 16, weight: .semibold))
                        .lineLimit(1)
                    Spacer()
                    Text(character.status.rawValue)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(character.status.labelColor)
                }
                Text(character.species)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Color(uiColor: .secondaryLabel))
            }
            .padding([.leading, .bottom, .trailing], 8)
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
