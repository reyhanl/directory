//
//  MockSearchInteractor.swift
//  MiniProjectUITests
//
//  Created by reyhan muhammad on 16/08/23.
//

import Foundation

class MockSearchInteractor: SearchPresenterToInteractorProtocol{
    var presenter: SearchInteractorToPresenterProtocol?
    
    var categories: [Category]?
    var filteredCategories: [Category]?
    
    func fetchData() {
        categories = MockDataProvider.getDummyCategories()
        filteredCategories = MockDataProvider.getDummyCategories()
        presenter?.result(result: .success(.fetchData(categories ?? [])))
    }
    
    func userSearchedFor(_ keyword: String) {
        categories = MockDataProvider.getDummyCategories()
        filteredCategories = MockDataProvider.getDummyCategories()
        categories?.first?.isExpanded = true
        categories?.first?.child?.first?.isExpanded = true
        let tempCategories = [categories!.first!]
        
        presenter?.result(result: .success(.search(tempCategories)))
    }
    
    func shouldEndSearch() {
        
    }
}
