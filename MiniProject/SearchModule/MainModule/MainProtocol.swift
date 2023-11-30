//
//  MainProtocol.swift
//  MiniProject
//
//  Created by reyhan muhammad on 12/08/23.
//

import Foundation
import CoreData

protocol MainViewToPresenterProtocol{
    var view: MainPresenterToViewProtocol? {get set}
    var router: MainPresenterToRouterProtocol? {get set}
    
    func viewWillAppear()
    func showSearchVC(view: MainPresenterToViewProtocol)
    func userSaveCategory(category: Category)
    func userClickOnSavedCategories(category name: String)
    func userDeleteSavedCategory(with names: [String])
}

protocol MainPresenterToViewProtocol{
    var presenter: MainViewToPresenterProtocol? {get set}
    
    func result(result: Result<MainModuleSuccess, Error>)
}

protocol MainInteractorToPresenterProtocol{
    var interactor: MainPresenterToInteractorProtocol? {get set}
    
    func result(result: Result<MainModuleSuccess, Error>)
}

protocol MainPresenterToInteractorProtocol{
    var presenter: MainInteractorToPresenterProtocol? {get set}
    
    func fetchData()
    func userSaveCategory(category: Category)
    func userDeleteSavedCategory(with names: [String])
}

protocol MainPresenterToRouterProtocol{
    static func makeComponent(container: NSPersistentContainer) -> MainViewController
    func showSearchVC(view: MainPresenterToViewProtocol)
    func showSearchVC(view: MainPresenterToViewProtocol, search keyword: String)
}

enum MainModuleSuccess{
    case successfullyDeleted([String])
    case successfullyRetrieveData([Category])
    case successfullySavingData
}
