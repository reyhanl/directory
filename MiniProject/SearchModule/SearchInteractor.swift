//
//  HomeViewControllerInteractor.swift
//  MiniProject
//
//  Created by reyhan muhammad on 11/08/23.
//

import Foundation

class SearchInteractor: SearchPresenterToInteractorProtocol{
    var presenter: SearchInteractorToPresenterProtocol?
    var categories: [Category]?
    var filteredCategories: [Category]?
    var isSearching: Bool = false
    var searchKeyword: String = ""
    var debounceTimer: Timer?
    var shouldAllowSearching: Bool = true
    var debounceInterval = 0.2
    
    func fetchData() {
       NetworkManager.shared.fetchCategories(completion: { result in
            switch result{
            case .success(let categories):
                self.categories = categories
                self.presenter?.result(result: .success(.fetchData(categories)))
            case .failure(let error):
                self.presenter?.result(result: .failure(error))
            }
        })
    }
    
    func userSearchedFor(_ keyword: String) {
        if shouldAllowSearching{
            debounceTimer?.invalidate() // Invalidate the existing timer (if any)
            shouldAllowSearching = false
            debounceTimer = Timer.scheduledTimer(withTimeInterval: debounceInterval, repeats: false) { [weak self] timer in
                timer.invalidate()
                self?.shouldAllowSearching = true
                self?.search(keyword)
            }
        }
    }
    
    func search(_ keyword: String){
        guard let categories = categories else{return}
        let tempFilteredCategories = filteredCategories ?? []
        var filteredCategories: [Category] = tempFilteredCategories
        if keyword.count < searchKeyword.count{
            filteredCategories = categories
        }
        searchKeyword = keyword
        let userJustBeginSearching = keyword.count == 1
        if userJustBeginSearching{
            filteredCategories = categories
        }
        var shouldBeRefreshRows: [Int] = []
        if !isSearching{
            filteredCategories = categories
            isSearching = true
        }
        var tempCategories: [Category] = []
        for (index, category) in filteredCategories.enumerated() {
            let containSearchCriteria = findCategory(category, search: keyword)
            if containSearchCriteria{
                shouldBeRefreshRows.append(index)
                tempCategories.append(category)
            }
        }
        updateDataToView()
        
        func updateDataToView(){
            self.filteredCategories = tempCategories
            presenter?.result(result: .success(.search(tempCategories)))
        }
    }
    
    func findCategory(_ category: Category, search: String) -> Bool{
        var filteredCategories: [Category] = []
        var containChildrenWithSearchCriteria = false
        
        if (category.name ?? "").contains(search){
            filteredCategories.append(category)
            containChildrenWithSearchCriteria = true
        }else{
            category.isExpanded = false
        }
        
        guard let children = category.child else{return containChildrenWithSearchCriteria}
        var shouldExpandCategory: Bool = false //Should expand the parent Category
        for child in children{
            let temp = findCategory(child, search: search)
            if temp{
                containChildrenWithSearchCriteria = true
                category.isExpanded = true
                shouldExpandCategory = true
            }else{
                child.isExpanded = false
            }
        }
        
        category.isExpanded = shouldExpandCategory
        
        //Ensure that every data is going to be displayed when user start typing from zero after previously deleting the searchKeyWord
        if search == ""{
            category.isExpanded = false
            return true
        }
        
        return containChildrenWithSearchCriteria
    }
    
    func shouldEndSearch() {
        //Since we need to individually get every Category.isExpanded to false, we have two option which are to call and request new data or turn it to false by iterating through it
        guard let categories = categories else{return}
        isSearching = false
        presenter?.result(result: .success(.search(categories)))
    }
    
    func postRefreshNotification(_ indexes: [Int]){
        NotificationCenter.default.post(name: Notification.Name("shouldRefreshRowsu"), object: indexes, userInfo: nil)
    }
}
