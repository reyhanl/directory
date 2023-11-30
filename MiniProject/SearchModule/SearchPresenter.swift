//
//  HomeViewControllerPresenter.swift
//  MiniProject
//
//  Created by reyhan muhammad on 11/08/23.
//

import Foundation

class SearchPresenter: SearchViewToPresenterProtocol{
    var interactor: SearchPresenterToInteractorProtocol?
    var view: SearchPresenterToViewProtocol?
    var router: SearchPresenterToRouterProtocol?
    
    func viewDidLoad() {
        interactor?.fetchData()
    }
    
    func userSearchFor(_ keyword: String) {
        interactor?.userSearchedFor(keyword)
    }
    
    func shouldEndSearch() {
        interactor?.shouldEndSearch()
    }
}

extension SearchPresenter: SearchInteractorToPresenterProtocol{
    func result(result: Result<SearchSuccessType, Error>) {
        view?.result(result: result)
    }
}
