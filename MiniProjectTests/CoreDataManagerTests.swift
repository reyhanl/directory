//
//  MiniProjectTests.swift
//  MiniProjectTests
//
//  Created by Nakama on 08/11/20.
//

import XCTest
import MiniProject
import CoreData

class CoreDataManagerTests: XCTestCase{
    
    var app: XCUIApplication?
    
    var coreDataHelper: CoreDataHelperProtocol?
    var categories: [Category] = []
    var container: DataContainer = .category
    let entity: EntityName = .category
    
    override func setUpWithError() throws {
        let container = NSPersistentContainer(name: DataContainer.category.rawValue)
        container.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
        
        coreDataHelper = CoreDataHelper.init(coreDataStack: .init(persistent: container))
        let categories = MockDataProvider.getDummyCategories()
        self.categories = categories
    }

    override func tearDownWithError() throws {
        coreDataHelper = nil
        categories = []
    }

    
    func testInserCategory(){
        guard let coreDataHelper = coreDataHelper else{return}
        for category in categories {
            let _ = coreDataHelper.saveNewData(entity: container.categoryModel, object: category)
        }
        
        let result: [Category] = coreDataHelper.fetchItemsToGeneric(entity: entity, with: nil)
        XCTAssert(result.count == categories.count && result.count > 0, "Data fetched is not matching with data inserted")
        XCTAssert((result.first?.name ?? "") == categories.first?.name)
    }
    
    func testDeleteAllDataFromCategory(){
        guard let coreDataHelper = coreDataHelper else{return}
        insertDataToContainer()
        let _ = coreDataHelper.deleteAllRecords(entity: entity)
        
        let result: [Category] = coreDataHelper.fetchItemsToGeneric(entity: entity, with: nil)
        XCTAssert(result.count == 0, "There is still some data left")
        
    }
    
    func insertDataToContainer(){
        guard let coreDataHelper = coreDataHelper else{return}
        for category in categories {
            let _ = coreDataHelper.saveNewData(entity: container.categoryModel, object: category)
        }
    }
    
    override func tearDown() {
        coreDataHelper = nil
    }
}
