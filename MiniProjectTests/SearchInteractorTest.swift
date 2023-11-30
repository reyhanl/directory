//
//  NetworkingTest.swift
//  MiniProjectTests
//
//  Created by reyhan muhammad on 15/08/23.
//

import XCTest

final class SearchInteractorTest: XCTestCase {
    
    var presenter: MockSearchPresenter?
    var interactor: SearchPresenterToInteractorProtocol?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        interactor = SearchInteractor()
        presenter = MockSearchPresenter()
        
        interactor?.presenter = presenter
        presenter?.interactor = interactor
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        interactor = nil
        presenter = nil
        
    }

    func testSearchInteractorFetchData() throws {
        let expectation = XCTestExpectation(description: "API call completed")
        interactor?.fetchData()
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
            if self.presenter?.categories != nil{
                expectation.fulfill()
            }
            timer.invalidate()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testSearchInteractorSearchFeature() throws {
        let expectation = XCTestExpectation(description: "Search completed")
        interactor?.categories = MockDataProvider.getDummyCategories()
        interactor?.userSearchedFor("Category 1 first child")
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
            
            if let categories = self.presenter?.categories,
               categories.count == 1,
               let category = categories.first,
               category.name == "Category 1",
               category.isExpanded
            {
                expectation.fulfill()
            }
            timer.invalidate()
        }
        wait(for: [expectation], timeout: 10)
    }

    func testPerformanceExample() throws {
        self.measure {
        }
    }

}

class MockSearchPresenter: SearchInteractorToPresenterProtocol{
    var interactor: SearchPresenterToInteractorProtocol?
    var categories: [Category]?
    
    func result(result: Result<SearchSuccessType, Error>) {
        switch result{
        case .success(let type):
            switch type{
            case .fetchData(let categories):
                self.categories = categories
            case .search(let categories):
                self.categories = categories
            }
        case .failure(_):
            break
        }
    }
}
