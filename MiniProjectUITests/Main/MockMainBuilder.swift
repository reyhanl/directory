//
//  MockMainBuilder.swift
//  MiniProjectUITests
//
//  Created by reyhan muhammad on 16/08/23.
//

import Foundation

final class MainBuilder {
    
    static func build(withData: Bool, router: MainPresenterToRouterProtocol? = nil) -> MainViewController {
        var interactor: MainPresenterToInteractorProtocol = MockMainInteractor(withData: withData)
        var presenter: MainViewToPresenterProtocol & MainInteractorToPresenterProtocol = MainPresenter()
        let view = MainViewController()
        let router: MainPresenterToRouterProtocol = router ?? MainRouter()
        
        view.presenter = presenter
        interactor.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        return view
    }
}
