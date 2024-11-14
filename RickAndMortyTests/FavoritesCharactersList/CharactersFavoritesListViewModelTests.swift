//
//  CharactersFavoritesListViewModelTests.swift
//  RickAndMorty
//
//  Created by Leandro Berli on 12/11/2024.
//

import XCTest
@testable import RickAndMorty


final class FavoritesCharactersListViewModelTests: XCTestCase {
    var sut: FavoritesCharactersListViewModel!
    
    override func setUpWithError() throws {
        sut = FavoritesCharactersListViewModel()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testRemoveFavoriteShouldUpdateDataArray() throws {
        //Load/Update favorites array
        sut.setFavoritesCharacters()
        
        if !sut.characters.isEmpty {
            let firstFavorite = sut.characters.first!
            sut.toggleFavorite(character: firstFavorite)
            
            //Update
            sut.setFavoritesCharacters()
            XCTAssertFalse(sut.characters.contains(firstFavorite))
        } else {
            //Add random favorite.
            var favoritableCharacters = MockRAMCharactersService().mockedData.results.map({ FavoritableCharacter(data: $0)})
            favoritableCharacters[0].isFavorite = true
            
            //Update favorites list and check thats was added.
            sut.setFavoritesCharacters()
            XCTAssertFalse(sut.characters.isEmpty)

            //Remove to favorite list, update and check thats is empty.
            sut.toggleFavorite(character: favoritableCharacters[0])
            sut.setFavoritesCharacters()
            XCTAssertTrue(sut.characters.isEmpty)
        }
    }
}

