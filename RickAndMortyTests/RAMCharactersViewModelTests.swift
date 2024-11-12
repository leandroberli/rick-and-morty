//
//  RickAndMortyTests.swift
//  RickAndMortyTests
//
//  Created by Leandro Berli on 25/10/2024.
//

import XCTest
@testable import RickAndMorty
import Combine

public final class MockRAMCharactersService: RAMCharactersServiceProtocol {
    let mockedData: GetAllCharactersResponse = loadJson(filename: "charactersResponse")!
    public func fetchCharacters(page: Int?, name: String?) -> AnyPublisher<GetAllCharactersResponse, any Error> {
        return Just(mockedData)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

func loadJson(filename fileName: String) -> GetAllCharactersResponse? {
    let bundle = Bundle(for: RAMCharactersViewModelTests.self)
    let path = bundle.path(forResource: fileName, ofType: "json")
    do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path ?? ""))
        let decoder = JSONDecoder()
        let jsonData = try decoder.decode(GetAllCharactersResponse.self, from: data)
        return jsonData
    } catch {
        return nil
    }
}


final class RAMCharactersViewModelTests: XCTestCase {
    var sut: RAMCharactersListViewModel!
    var mockCharactersService: MockRAMCharactersService!
    
    override func setUpWithError() throws {
        mockCharactersService = MockRAMCharactersService()
        sut = RAMCharactersListViewModel(charactersService: mockCharactersService)
    }
    
    override func tearDownWithError() throws {
        mockCharactersService = nil
        sut = nil
    }
    
    func testSetInitiallyLoadedCharacters() throws {
        XCTAssertTrue(sut.characters.isEmpty)
        
        sut.setCharactersFirstPage()
        
        let expectation = XCTestExpectation(description: "Wait for cities to be fetched")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertFalse(self.sut.characters.isEmpty)
            XCTAssertNotEqual(self.sut.characters.count, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testFetchingSecondPage() throws {
        XCTAssertTrue(sut.characters.isEmpty)
        
        sut.setCharactersFirstPage()
        
        let expectation = XCTestExpectation(description: "Wait for characters to be fetched")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertFalse(self.sut.characters.isEmpty)
            XCTAssertNotEqual(self.sut.characters.count, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
        
        let expectation2 = XCTestExpectation(description: "Wait for characters to be fetched")
        
        sut.setNextCharactersPageIfExists()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertEqual(self.sut.paginationManager.currentPage, 2)
            expectation2.fulfill()
        }
        
        wait(for: [expectation2], timeout: 5)
    }
    
    func testSearchingByNameOKResponse() throws {
        let expectation = XCTestExpectation(description: "Wait for characters to be fetched")
        
        //Setup search status
        sut.searchString = "Rick"
        sut.searchCharacters()
        
        //Wait to fetch
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertFalse(self.sut.characters.isEmpty)
            XCTAssertTrue(self.sut.characters.first!.data.name.contains("Rick"))
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testSearchingByNameBadResponse() throws {
        let expectation = XCTestExpectation(description: "Wait for characters to be fetched")
        
        //Setup search status
        sut.searchString = "Rick"
        sut.searchCharacters()
        
        //Wait to fetch
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertFalse(self.sut.characters.isEmpty)
            XCTAssertFalse(self.sut.characters.first!.data.name.contains("Morty"))
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testFavoriteCharactersShouldBeStoraged() throws {
        XCTAssertTrue(sut.characters.isEmpty)
        
        sut.setCharactersFirstPage()
        
        let expectation = XCTestExpectation(description: "Wait for characters to be fetched")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertFalse(self.sut.characters.isEmpty)
            
            //TODO: TMP Fix
            let rickFavCharacter = self.sut.characters[0]
            //Force remove to defualts to success test
            UserDefaults.standard.set(nil, forKey: "\(rickFavCharacter.data.id)")
            
            XCTAssertFalse(rickFavCharacter.isFavorite)
            
            self.sut.toggleFavorite(character: rickFavCharacter.data)
            
            XCTAssertTrue(UserDefaults.standard.bool(forKey: "\(rickFavCharacter.data.id)"))
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testFavoriteAndUnfavoritedShouldRemoveStorage() throws {
        XCTAssertTrue(sut.characters.isEmpty)
        
        sut.setCharactersFirstPage()
        
        let expectation = XCTestExpectation(description: "Wait for characters to be fetched")
        
        //Wait to fetch
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertFalse(self.sut.characters.isEmpty)
            XCTAssertNotEqual(self.sut.characters.count, 0)
            
            //Add to favorite
            let mortyCharacter = self.sut.characters[1].data
            
            self.sut.toggleFavorite(character: mortyCharacter)
            XCTAssertTrue(UserDefaults.standard.bool(forKey: "\(mortyCharacter.id)"))
            
            //Remove to favorite
            self.sut.toggleFavorite(character: mortyCharacter)
            XCTAssertFalse(UserDefaults.standard.bool(forKey: "\(mortyCharacter.id)"))
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
//    
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
