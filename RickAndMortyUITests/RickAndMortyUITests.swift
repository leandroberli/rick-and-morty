//
//  RickAndMortyUITests.swift
//  RickAndMortyUITests
//
//  Created by Leandro Berli on 25/10/2024.
//

import XCTest


final class RickAndMortyUITests: XCTestCase {
    
    var server: MockServer!
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        app = XCUIApplication()
        server = MockServer()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app.launchArguments = ["-mockServer"]
        server.configureServer()
        server.startServer()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
        server = nil
    }

    @MainActor
    func testNavigationToRandomCharacterDetail() throws {
        let charName = "Rick Sanchez"
        let textName = app.staticTexts[charName]
        
        XCTAssertTrue(textName.waitForExistence(timeout: 20))
        textName.tap()
        
        let detailTitle = app.staticTexts[charName]
        
        XCTAssertTrue(detailTitle.waitForExistence(timeout: 5))
    }
    
    @MainActor
    func testNavigationDetailWithSearchShouldShowCharacterDetail() throws {
        let charName = "Beth Smith"
        let searchTextfield = app.searchFields.firstMatch
        
        XCTAssertTrue(searchTextfield.waitForExistence(timeout: 5))
        searchTextfield.tap()
        
        searchTextfield.typeText(charName)
        
        let exp = XCTestExpectation(description: "Wait to see results")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            let charNameText = self.app.staticTexts[charName]
            XCTAssertTrue(charNameText.waitForExistence(timeout: 5))
            charNameText.tap()
            
            let detailText = self.app.staticTexts[charName]
            XCTAssert(detailText.waitForExistence(timeout: 5))
            exp.fulfill()
        }
        
        self.wait(for: [exp])
    }
    
    @MainActor
    func testSearchWithNoResultsShouldShowNoResultsLabel() throws {
        let searchTextfield = app.searchFields.firstMatch
        XCTAssertTrue(searchTextfield.waitForExistence(timeout: 5))
        
        searchTextfield.tap()
        searchTextfield.typeText("No search results dummy text")
        
        let noResultsText = app.staticTexts["There is no results for the given name"]
        XCTAssertTrue(noResultsText.waitForExistence(timeout: 20))
    }

//    @MainActor
//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
