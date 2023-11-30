//
//  MainUITests.swift
//  MiniProjectTests
//
//  Created by reyhan muhammad on 14/08/23.
//

import XCTest
import MiniProject

final class MainUITests: XCTestCase {
    
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

    func testUIWithData() throws {
        // UI tests must launch the application that they test.
        guard let app = app else{return}
        app.launchArguments = ["MainUITest", "MainVCWithData"]
        app.launch()
        let titleLabel = app.staticTexts["You have chosen"]
        
        XCTAssertTrue(titleLabel.exists, "The title label should say 'You have chosen'")

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testUIWithNoData() throws {
        // UI tests must launch the application that they test.
        guard let app = app else{return}
        app.launchArguments = ["MainUITest", "MainVCWithNoData"]
        app.launch()
        let titleLabel = app.staticTexts["You have no selected categories"]
        
        XCTAssertTrue(titleLabel.exists, "The title label should say 'You have no selected categories'")

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testClickFirstRowFromTable(){
        guard let app = app else{return}
        app.launchArguments = ["MainUITest", "MainVCWithData"]
        app.launch()
        let table = app.tables.matching(identifier: "tableView")
        let cell = table.cells.matching(.cell, identifier: "cell\(0)")
        cell.element.tap()
        
        let tableView = app.tables["searchTable"]
        XCTAssertTrue(tableView.exists, "It should have presented SearchVC") //SearchVC has a searchBar
    }
    
    func testClickAddButton(){
        guard let app = app else{return}
        app.launchArguments = ["MainUITest", "MainVCWithData"]
        app.launch()
        
        let barButton = app.navigationBars.buttons["addCategoryButton"]
        barButton.tap()
        let tableView = app.tables["searchTable"]
        XCTAssertTrue(tableView.exists, "It should have presented SearchVC") //SearchVC has a searchBar
    }
    
    func testSelectButton(){
        guard let app = app else{return}
        app.launchArguments = ["MainUITest", "MainVCWithData"]
        app.launch()
        
        let barButton = app.navigationBars.buttons["selectButton"]
        barButton.tap()
        
        let table = app.tables.matching(identifier: "tableView")
        let cell = table.cells.matching(.cell, identifier: "cell\(0)")
        cell.element.tap()

        let tableView = app.tables["searchTable"]

        XCTAssertTrue(cell.element.isSelected, "It should select the cell")
        XCTAssertTrue(!tableView.exists, "It should not have presented SearchVC") //SearchVC has a searchBar
    }
    
    func testDeleteButton(){
        guard let app = app else{return}
        app.launchArguments = ["MainUITest", "MainVCWithData"]
        app.launch()
        
        let barButton = app.navigationBars.buttons["selectButton"]
        barButton.tap()
        
        //check if cell is selected
        let table = app.tables.matching(identifier: "tableView")
        let previousTableViewRowsCount = table.cells.count
        let cell = table.cells.matching(.cell, identifier: "cell\(0)")
        cell.element.tap()
        XCTAssertTrue(cell.element.isSelected, "It should select the cell")

        
        let removeAllButton = app.buttons["removeAllbutton"]
        removeAllButton.tap()
        
        //check if cell has been removed
        let currentTableViewRowsCount = table.cells.count
        print(previousTableViewRowsCount, currentTableViewRowsCount)
        XCTAssertTrue(previousTableViewRowsCount > currentTableViewRowsCount, "It should have deleted one element")
    }
}
