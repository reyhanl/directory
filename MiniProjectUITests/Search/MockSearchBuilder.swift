//
//  SearchBuilder.swift
//  MiniProjectUITests
//
//  Created by reyhan muhammad on 15/08/23.
//

import Foundation
import CoreData

final class SearchBuilder {
    static func build() -> SearchViewController {
        var interactor: SearchPresenterToInteractorProtocol = MockSearchInteractor()
        var presenter: SearchViewToPresenterProtocol & SearchInteractorToPresenterProtocol = SearchPresenter()
        let view = SearchViewController()
        let router: SearchPresenterToRouterProtocol = SearchRouter()
        
        view.presenter = presenter
        interactor.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        return view
    }
}
