//
//  MainPresenter.swift
//  MiniProject
//
//  Created by reyhan muhammad on 12/08/23.
//

import Foundation

class MainPresenter: MainViewToPresenterProtocol{
    var view: MainPresenterToViewProtocol?
    var interactor: MainPresenterToInteractorProtocol?
    var router: MainPresenterToRouterProtocol?
    
    
    func viewWillAppear() {
        interactor?.fetchData()
    }
    
    func showSearchVC(view: MainPresenterToViewProtocol) {
        router?.showSearchVC(view: view)
    }
    
    func userSaveCategory(category: Category) {
        interactor?.userSaveCategory(category: category)
    }
    
    func userClickOnSavedCategories(category name: String) {
        guard let view = view else{return}
        router?.showSearchVC(view: view, search: name)
    }
    
    func userDeleteSavedCategory(with names: [String]){
        interactor?.userDeleteSavedCategory(with: names)
    }
}

extension MainPresenter: MainInteractorToPresenterProtocol{
    func result(result: Result<MainModuleSuccess, Error>) {
        view?.result(result: result)
    }
}
