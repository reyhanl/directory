//
//  HomeRouter.swift
//  MiniProject
//
//  Created by reyhan muhammad on 11/08/23.
//

import Foundation
import UIKit

class SearchRouter: SearchPresenterToRouterProtocol{
    static func makeComponent(delegate: SearchViewControllerProtocol?) -> SearchViewController{
        var interactor: SearchPresenterToInteractorProtocol = SearchInteractor()
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
    
    static func makeComponent(delegate: SearchViewControllerProtocol?, search keyword: String) -> SearchViewController{
        var interactor: SearchPresenterToInteractorProtocol = SearchInteractor()
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
