//
//  RAMCharacterDetailView.swift
//  RickAndMorty
//
//  Created by Leandro Berli on 28/10/2024.
//

import SwiftUI

struct RAMCharacterDetailView: View {
    @State var character: Character
    let informationItemTitles: [String] = ["Status", "Specie", "Gender", "Episodes" ]
    
    var body: some View {
        ScrollView() {
            VStack(alignment: .leading) {
                ZStack(alignment: .bottomLeading) {
                    AsyncCachedImage(url: URL(string: character.image)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Image(systemName: "photo")
                            .imageScale(.large)
                            
                    }
                    Rectangle()                         // Shapes are resizable by default
                        .foregroundColor(.clear)        // Making rectangle transparent
                        .background(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom))
                    Text(character.name)
                        .font(.system(size: 36, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding()
                }
                Spacer()
                    .frame(height: 16)
                ForEach(informationItemTitles, id: \.self) { item in
                    VStack(alignment: .leading, spacing: 0) {
                        Text(item)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(Color(uiColor: .secondaryLabel))
                        Spacer()
                            .frame(height: 4)
                        switch item {
                        case "Status":
                            Text(character.status.textLabel)
                                .foregroundStyle(character.status.labelColor)
                                .font(.system(size: 16, weight: .medium))
                        case "Specie":
                            Text(character.species)
                                .font(.system(size: 16, weight: .medium))
                        case "Gender":
                            Text(character.gender)
                                .font(.system(size: 16, weight: .medium))
                        case "Episodes":
                            Text(character.episodeToString)
                            .font(.system(size: 16, weight: .medium))
                        default:
                            EmptyView()
                        }
                    }
                    .padding(.bottom, 8)
                    .padding([.leading, .trailing], 16)
                    .id(item)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("")
        }
    }
}
