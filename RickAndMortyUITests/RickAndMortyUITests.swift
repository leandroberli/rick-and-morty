//
//  RickAndMortyUITests.swift
//  RickAndMortyUITests
//
//  Created by Leandro Berli on 25/10/2024.
//

import XCTest

final class RickAndMortyUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    @MainActor
    func testNavigationToRandomCharacterDetail() throws {
        let charsName = ["Beth Smith", "Summer Smith", "Morty Smith", "Rick Sanchez"]
        let randomChar = charsName.randomElement()!
        
        let textName = app.staticTexts[randomChar]
        
        XCTAssertTrue(textName.waitForExistence(timeout: 120))
        textName.tap()
        
        let detailTitle = app.staticTexts[randomChar]
        
        XCTAssertTrue(detailTitle.waitForExistence(timeout: 120))
    }
    
    @MainActor
    func testNavigationDetailWithSearchShouldShowCharacterDetail() throws {
        let charName = "Glasses Morty"
        let searchTextfield = app.searchFields.firstMatch
        
        XCTAssertTrue(searchTextfield.waitForExistence(timeout: 240))
        searchTextfield.tap()
        
        searchTextfield.typeText(charName)
        
        let charNameText = app.staticTexts[charName]
        XCTAssertTrue(charNameText.waitForExistence(timeout: 120))
        charNameText.tap()
        
        let detailText = app.staticTexts[charName]
        XCTAssert(detailText.waitForExistence(timeout: 120))
    }
    
    @MainActor
    func testSearchWithNoResultsShouldShowNoResultsLabel() throws {
        let searchTextfield = app.searchFields.firstMatch
        
        XCTAssertTrue(searchTextfield.waitForExistence(timeout: 120))
        searchTextfield.tap()
        searchTextfield.typeText("No search results dummy text")
        
        let charNameText = app.staticTexts["There is no results for the given name"]
        XCTAssertTrue(charNameText.waitForExistence(timeout: 120))
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
