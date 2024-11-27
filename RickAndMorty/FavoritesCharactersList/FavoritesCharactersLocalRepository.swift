//
//  FavoritesCharactersLocalRepository.swift
//  RickAndMorty
//
//  Created by Leandro Berli on 13/11/2024.
//

import Foundation

protocol FavoritesCharactersRepositoryProtocol {
    func save(_ character: FavoritableCharacter)
    func remove(character: FavoritableCharacter)
    func getFavoritesCharacters() -> [FavoritableCharacter]
}

public final class FavoritesCharactersLocalRepository: FavoritesCharactersRepositoryProtocol {
    static let keyName = "favoritesCharactersData"
    
    public init() {}
        
    public func getFavoritesCharacters() -> [FavoritableCharacter] {
        loadFavorites()
    }
    
    func save(_ character: FavoritableCharacter) {
        // Retrieve current favorites or initialize an empty array if none exist
        var currentFavorites = loadFavorites()
        
        // Append new character
        if !currentFavorites.contains(where: { $0.data.id == character.data.id }) {
            currentFavorites.append(character)
        }
        
        // Save updated list
        if let data = try? JSONEncoder().encode(currentFavorites) {
            UserDefaults.standard.set(data, forKey: FavoritesCharactersLocalRepository.keyName)
        }
    }
    
    func remove(character: FavoritableCharacter) {
        var currentFavorites = loadFavorites()
        if let index = currentFavorites.firstIndex(where: { $0.data.id == character.data.id }) {
            currentFavorites.remove(at: index)
        }
        // Save updated list
        if let data = try? JSONEncoder().encode(currentFavorites) {
            UserDefaults.standard.set(data, forKey: FavoritesCharactersLocalRepository.keyName)
        }
    }

    func loadFavorites() -> [FavoritableCharacter] {
        guard let data = UserDefaults.standard.data(forKey: FavoritesCharactersLocalRepository.keyName),
              let favorites = try? JSONDecoder().decode([FavoritableCharacter].self, from: data) else {
            return []
        }
        return favorites
    }
}
