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

struct FavoritableCharacter: FavoritableProtocol, Hashable {
    var data: Character
    
    var isFavorite: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: data.idString)
        }
        get {
            UserDefaults.standard.bool(forKey: data.idString)
        }
    }
}
