//
//  Favorites.swift
//  RickAndMorty
//
//  Created by Leandro Berli on 12/11/2024.
//
import Combine
import Foundation

protocol FavoritableCharacterFeature {
    var characters: [FavoritableCharacter] { get set }
    func toggleFavorite(character: FavoritableCharacter)
}

public final class FavoritesCharactersListViewModel: FavoritableCharacterFeature, ObservableObject {
    @Published var characters: [FavoritableCharacter] = []
    private var repository: FavoritesCharactersRepositoryProtocol
    
    init(repository: FavoritesCharactersRepositoryProtocol = FavoritesCharactersLocalRepository()) {
        self.repository = repository
    }
    
    public func setFavoritesCharacters() {
        characters = repository.getFavoritesCharacters()
    }
    
    func toggleFavorite(character: FavoritableCharacter) {
        if let index = characters.firstIndex(where: { $0.data.id == character.data.id }) {
            characters[index].isFavorite = !characters[index].isFavorite
        }
    }
}


