//
//  RAMCharactersViewModel.swift
//  RickAndMorty
//
//  Created by Leandro Berli on 25/10/2024.
//
import Foundation

final class RAMCharactersListViewModel: ObservableObject {
    @Published public var characters: [Character] = []
    private var charactersService: RAMCharactersServiceProtocol
    
    init(characters: [Character] = [],
         charactersService: RAMCharactersServiceProtocol = RAMCharactersService()) {
        self.characters = characters
        self.charactersService = charactersService
    }
    
    public func setCharacters() {
        charactersService.fetchCharacters()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] response in
                guard let self = self else {
                    return
                }
                self.characters = response.results
            })
    }
}

