//
//  RickAndMortyTests.swift
//  RickAndMortyTests
//
//  Created by Leandro Berli on 25/10/2024.
//

import XCTest
@testable import RickAndMorty

final class RAMCharactersViewModelTests: XCTestCase {
    
    var sut: RAMCharactersListViewModel!
    
    override func setUpWithError() throws {
        sut = RAMCharactersListViewModel()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testSetInitiallyLoadedCharacters() throws {
        XCTAssertTrue(sut.characters.isEmpty)
        
        sut.setCharacters()
        
        let expectation = XCTestExpectation(description: "Wait for cities to be fetched")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(self.sut.characters.isEmpty)
            XCTAssertNotEqual(self.sut.characters.count, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
