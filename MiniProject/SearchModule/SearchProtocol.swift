//
//  HomeProtocol.swift
//  MiniProject
//
//  Created by reyhan muhammad on 11/08/23.
//

import Foundation

protocol SearchPresenterToViewProtocol{
    var presenter: SearchViewToPresenterProtocol?{get set}
    func result(result: Result<SearchSuccessType, Error>)
}

protocol SearchPresenterToInteractorProtocol{
    var presenter: SearchInteractorToPresenterProtocol? { get set }
    var categories: [Category]?{get set}
    var filteredCategories: [Category]?{get set}
    func fetchData()
    func userSearchedFor(_ keyword: String)
    func shouldEndSearch()
}

protocol SearchViewToPresenterProtocol{
    var view: SearchPresenterToViewProtocol? {get set}
    var router: SearchPresenterToRouterProtocol? {get set}
    func viewDidLoad()
    func userSearchFor(_ keyword: String)
    func shouldEndSearch()
}

protocol SearchInteractorToPresenterProtocol{
    var interactor: SearchPresenterToInteractorProtocol? {get set}
    func result(result: Result<SearchSuccessType, Error>)
}

protocol SearchPresenterToRouterProtocol{
    static func makeComponent(delegate: SearchViewControllerProtocol?) -> SearchViewController
    static func makeComponent(delegate: SearchViewControllerProtocol?, search keyword: String) -> SearchViewController
}

protocol SearchViewControllerProtocol{
    func didFinishPicking(category: Category)
}

protocol CategoryTableViewCellDelegate{
    func userSelectChildCategory(category: Category)
    func userSavedCategory(category: Category)
    func userSelectParentCategory(category: Category)
}

enum SearchSuccessType{
    case fetchData([Category])
    case search([Category])
}


