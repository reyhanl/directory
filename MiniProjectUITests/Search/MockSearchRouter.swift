//
//  MockSearchRouter.swift
//  MiniProjectUITests
//
//  Created by reyhan muhammad on 16/08/23.
//

import Foundation

class MockSearchRouter: SearchPresenterToRouterProtocol{
    static func makeComponent(delegate: SearchViewControllerProtocol?) -> SearchViewController {
        var interactor: SearchPresenterToInteractorProtocol = MockSearchInteractor()
        var presenter: SearchViewToPresenterProtocol & SearchInteractorToPresenterProtocol = SearchPresenter()
        let router: SearchPresenterToRouterProtocol = SearchRouter()
        let view = SearchViewController()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        view.delegate = delegate
        
        return view
    }
    
    static func makeComponent(delegate: SearchViewControllerProtocol?, search keyword: String) -> SearchViewController {
            var interactor: SearchPresenterToInteractorProtocol = MockSearchInteractor()
            var presenter: SearchViewToPresenterProtocol & SearchInteractorToPresenterProtocol = SearchPresenter()
            let router: SearchPresenterToRouterProtocol = SearchRouter()
            let view = SearchViewController()
            
            view.presenter = presenter
            presenter.view = view
            presenter.interactor = interactor
            presenter.router = router
            interactor.presenter = presenter
            
            view.delegate = delegate
            view.searchKeyword = keyword
            
            return view
    }
}
