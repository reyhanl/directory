//
//  MainRouter.swift
//  MiniProject
//
//  Created by reyhan muhammad on 12/08/23.
//

import Foundation
import CoreData

class MainRouter: MainPresenterToRouterProtocol{
    static func makeComponent(container: NSPersistentContainer) -> MainViewController {
        var interactor: MainPresenterToInteractorProtocol = MainInteractor(coreDataStack: .init(persistent: container))
        var presenter: MainViewToPresenterProtocol & MainInteractorToPresenterProtocol = MainPresenter()
        let view = MainViewController()
        let router: MainPresenterToRouterProtocol = MainRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
    
    func showSearchVC(view: MainPresenterToViewProtocol) {
        guard let mainVC = view as? MainViewController else {
            fatalError("Invalid View Protocol type")
        }
        let searchVC = SearchRouter.makeComponent(delegate: mainVC)

        mainVC.present(searchVC, animated: true, completion: nil)
    }
    
    func showSearchVC(view: MainPresenterToViewProtocol, search keyword: String) {
        guard let mainVC = view as? MainViewController else {
            fatalError("Invalid View Protocol type")
        }
        let searchVC = SearchRouter.makeComponent(delegate: mainVC, search: keyword)

        mainVC.present(searchVC, animated: true, completion: nil)
    }
    
}
