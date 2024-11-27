//
//  FavoritableProtocol.swift
//  RickAndMorty
//
//  Created by Leandro Berli on 29/10/2024.
//

import Foundation

protocol FavoritableProtocol {
    var isFavorite: Bool { get set }
}

public struct FavoritableCharacter: FavoritableProtocol, Hashable {
    
    static var placeholder: FavoritableCharacter {
        .init(data: Character(id: -1, name: "Placeholder", image: "", status: .alive, species: "", gender: "", episode: []))
    }
    
    var data: Character
    
    var isFavorite: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: data.idString)
            if newValue {
                FavoritesCharactersLocalRepository().save(self)
            } else {
                FavoritesCharactersLocalRepository().remove(character: self)
            }
        }
        get {
            UserDefaults.standard.bool(forKey: data.idString)
        }
    }
}

//Necessary to save data into UserDefaults.
extension FavoritableCharacter: Codable {
    
}
