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
    
    @State var character: Character
    let informationItemTitles: [DetailSection] = [.status, .specie, .gender, .episodes ]
    
    var body: some View {
        ScrollView() {
            VStack(alignment: .leading) {
                ZStack(alignment: .bottomLeading) {
                    characterImageView
                    Rectangle()                         // Shapes are resizable by default
                        .foregroundColor(.clear)        // Making rectangle transparent
                        .background(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom))
                    titleText
                }
                Spacer()
                    .frame(height: 16)
                characterDetailsView
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("")
        }
    }
    
    private var characterImageView: some View {
        AsyncCachedImage(url: URL(string: character.image)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            Image(systemName: "photo")
                .imageScale(.large)
                
        }
    }
    
    private var titleText: some View {
        Text(character.name)
            .font(.system(size: 36, weight: .semibold))
            .foregroundStyle(.white)
            .padding()
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
                    Text(character.status.textLabel)
                        .foregroundStyle(character.status.labelColor)
                        .font(.system(size: 16, weight: .medium))
                case .specie:
                    Text(character.species)
                        .font(.system(size: 16, weight: .medium))
                case .gender:
                    Text(character.gender)
                        .font(.system(size: 16, weight: .medium))
                case .episodes:
                    Text(character.episodeToString)
                    .font(.system(size: 16, weight: .medium))
                }
            }
            .padding(.bottom, 8)
            .padding([.leading, .trailing], 16)
            .id(item)
        }
    }
}
