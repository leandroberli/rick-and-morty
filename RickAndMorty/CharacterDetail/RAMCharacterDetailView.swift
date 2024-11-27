//
//  RAMCharacterDetailView.swift
//  RickAndMorty
//
//  Created by Leandro Berli on 28/10/2024.
//

import SwiftUI

struct RAMCharacterDetailView: View {
    
    enum DetailSection {
        case status
        case specie
        case gender
        case episodes
        
        var title: String {
            switch self {
            case .status: return "STATUS"
            case .specie: return "SPECIE"
            case .gender: return "GENDER"
            case .episodes: return "EPISODES"
            }
        }
    }
    
    @Binding var character: FavoritableCharacter
    let informationItemTitles: [DetailSection] = [.status, .specie, .gender, .episodes ]
    
    var body: some View {
        ScrollView() {
            VStack(alignment: .leading) {
                ZStack(alignment: .bottomLeading) {
                    characterImageView
                    gradientOverlayView
                    HStack(alignment: .center, spacing: 0) {
                        titleText
                        Spacer()
                        favoriteButtonView
                    }
                }
                Spacer()
                    .frame(height: 16)
                characterDetailsView
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("")
        }
    }
    
    private var gradientOverlayView: some View {
        Rectangle()
            .foregroundColor(.clear)
            .background(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom))
    }
    
    private var favoriteButtonView: some View {
        Button(action: {
            character.isFavorite = !character.isFavorite
        }, label: {
            Image(systemName: character.isFavorite ? "heart.fill" : "heart")
                .resizable()
                .frame(width: 24, height: 24)
        })
        .tint(.green)
        .padding(.trailing, 16)
        .padding([.leading], 8)
        .padding(.top, 2)
    }
    
    private var characterImageView: some View {
        AsyncCachedImage(url: URL(string: character.data.image)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            Image(systemName: "photo")
                .imageScale(.large)
        }
    }
    
    private var titleText: some View {
        Text(character.data.name)
            .font(.system(size: 36, weight: .semibold))
            .foregroundStyle(.white)
            .padding([.leading], 16)
    }
    
    private var characterDetailsView: some View {
        ForEach(informationItemTitles, id: \.self) { item in
            VStack(alignment: .leading, spacing: 0) {
                Text(item.title)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Color(uiColor: .secondaryLabel))
                Spacer()
                    .frame(height: 4)
                switch item {
                case .status:
                    Text(character.data.status.textLabel)
                        .foregroundStyle(character.data.status.labelColor)
                        .font(.system(size: 16, weight: .medium))
                case .specie:
                    Text(character.data.species)
                        .font(.system(size: 16, weight: .medium))
                case .gender:
                    Text(character.data.gender)
                        .font(.system(size: 16, weight: .medium))
                case .episodes:
                    ForEach(character.data.episode.indices, id: \.self) { index in
                        HStack {
                            Text(character.data.episode[index].formatURLEpisodeToLabelString())
                            Spacer()
                            Button(action: {}, label: {
                                Image(systemName: "chevron.right")
                            })
                        }
                        .padding([.top, .bottom], 4)
                        .background(index % 2 == 0 ? .red : .green)
                    }
                    
                }
            }
            .padding(.bottom, 8)
            .padding([.leading, .trailing], 16)
            .id(item)
        }
    }
}
