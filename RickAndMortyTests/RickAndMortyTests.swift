//
//  RickAndMortyTests.swift
//  RickAndMortyTests
//
//  Created by Leandro Berli on 25/10/2024.
//

import XCTest
@testable import RickAndMorty

final class RickAndMortyTests: XCTestCase {
    
    var sut: RAMCharactersService!

    override func setUpWithError() throws {
        sut = RAMCharactersService()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testFetchAllCharactersNotNilResponse() throws {
        let expectation = expectation(description: "Waiting to fetch characters")
        
        sut.fetchCharacters()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
                XCTFail()
            }, receiveValue: { response in
                print(response)
                XCTAssertNotNil(response)
                expectation.fulfill()
            })
        
        self.wait(for: [expectation], timeout: 200)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
