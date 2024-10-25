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
        [GridItem(.flexible()), GridItem(.flexible())]
    }
    
    var itemWidth: CGFloat {
        UIScreen.main.bounds.width / 3
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(viewModel.characters, id: \.self) { character in
                        VStack(alignment: .leading, spacing: 8) {
                            AsyncImage(url: URL(string: character.image)) { image in
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
                                    Spacer()
                                    Text(character.status)
                                        .font(.system(size: 12, weight: .regular))
                                }
                                Text(character.species)
                                    .font(.system(size: 12, weight: .regular))
                            }
                            .padding([.leading, .bottom, .trailing],8)
                        }
                        .border(.gray)
                    }
                }
                .padding([.leading, .bottom, .trailing])
            }
            .navigationTitle("Characters")
            .searchable(text: $searchText)
        }
        .onAppear {
            viewModel.setCharacters()
        }
    }
}
