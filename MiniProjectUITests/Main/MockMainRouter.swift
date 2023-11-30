//
//  MockMainRouter.swift
//  MiniProjectUITests
//
//  Created by reyhan muhammad on 16/08/23.
//

import Foundation
import CoreData

class MockMainRouter: MainPresenterToRouterProtocol{
    static func makeComponent(container: NSPersistentContainer) -> MainViewController {
        let vc = MainBuilder.build(withData: true, router: MockMainRouter())
        return vc
    }
    
    func showSearchVC(view: MainPresenterToViewProtocol) {
        guard let mainVC = view as? MainViewController else {
            fatalError("Invalid View Protocol type")
        }
        let searchVC = MockSearchRouter.makeComponent(delegate: mainVC)
        
        mainVC.present(searchVC, animated: true, completion: nil)
    }
    
    func showSearchVC(view: MainPresenterToViewProtocol, search keyword: String) {
        guard let mainVC = view as? MainViewController else {
            fatalError("Invalid View Protocol type")
        }
        let searchVC = MockSearchRouter.makeComponent(delegate: mainVC, search: keyword)

        mainVC.present(searchVC, animated: true, completion: nil)
    }
}
