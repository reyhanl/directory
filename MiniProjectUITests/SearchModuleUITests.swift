//
//  MainUITests.swift
//  MiniProjectTests
//
//  Created by reyhan muhammad on 14/08/23.
//

import XCTest
import MiniProject

final class SearchUITests: XCTestCase {
    
    var app: XCUIApplication?


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        let app = XCUIApplication()
        self.app = app
    }

    override func tearDownWithError() throws {
        self.app = nil
    }

    func testVCCanBeDisplayed() throws {
        // UI tests must launch the application that they test.
        guard let app = app else{return}
        app.launchArguments = ["SearchUITest", "MainVCWithData"]
        app.launch()
        let table = app.tables.matching(identifier: "tableView")
        let cell = table.cells.matching(.cell, identifier: "cell\(0)")
        cell.element.tap()
        let searchTable = app.tables.matching(identifier: "searchTable")
        XCTAssertTrue(searchTable.element.exists, "SearchVC is not displayed")
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testCollapseACell() throws{
        guard let app = app else{return}
        app.launchArguments = ["SearchUITest", "MainVCWithData"]
        app.launch()
        let table = app.tables.matching(identifier: "tableView")
        let cell = table.cells.matching(.cell, identifier: "cell\(0)")
        cell.element.tap()
        let searchTable = app.tables.matching(identifier: "searchTable")
        let searchCell = app.otherElements["searchHeader\(0)"]
        searchCell.tap()
        XCTAssertTrue(searchTable.cells.count == 0, "Tableviewcell is not collapsing")
    }
    
}
