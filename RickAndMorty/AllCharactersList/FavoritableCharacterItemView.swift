//
//  FavoritableCharacterItemView.swift
//  RickAndMorty
//
//  Created by Leandro Berli on 13/11/2024.
//

import SwiftUI

struct FavoritableCharacterItemView: View {
    var character: FavoritableCharacter
    
    let toggleFavoriteAction: (FavoritableCharacter) -> Void
    
    var itemWidth: CGFloat {
        UIScreen.main.bounds.width / 2 - 16
    }
    
    var itemHeight: CGFloat {
        (UIScreen.main.bounds.height - 44 - 20) / 3.5
    }
    
    var body: some View {
        characterGridItemView(character: character.data)
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
                        toggleFavoriteAction(FavoritableCharacter(data: character))
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
}
