//
//  MainInteractor.swift
//  MiniProject
//
//  Created by reyhan muhammad on 12/08/23.
//

import Foundation

class MainInteractor: MainPresenterToInteractorProtocol{
    var presenter: MainInteractorToPresenterProtocol?
    let coreDataStack: CoreDataStack?
    let storageManager: CoreDataHelper?
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.storageManager = CoreDataHelper(coreDataStack: coreDataStack)
    }
    
    func fetchData() {
        guard let storageManager = storageManager else{
            presenter?.result(result: .failure(CustomError.somethingWentWrong))
            return
        }
        let models: [Category] = storageManager.fetchItemsToGeneric(entity: .category, with: nil)
        presenter?.result(result: .success(.successfullyRetrieveData(models)))
    }
    
    func userSaveCategory(category: Category) {
        guard let storageManager = storageManager,
              let name = category.name,
              !storageManager.checkIfDataAlreadyExist(entity: .category, predicate: NSPredicate(format: "name = %@", name))
        else{
            self.presenter?.result(result: .failure(CustomError.dataAlreadyExist))
            return
        }
        let result = storageManager.saveNewData(entity: .category, object: category)
        switch result{
        case .success(_):
            self.fetchData()
            self.presenter?.result(result: .success(.successfullySavingData))
        case .failure(let error):
            self.presenter?.result(result: .failure(error))
        }
    }
    
    func userDeleteSavedCategory(with names: [String]){
        let dispatchGroup = DispatchGroup()
        var deletedNames: [String] = []
        for name in names{
            dispatchGroup.enter()
            let predicate = NSPredicate(format: "any name == %@", name)
            let result = storageManager?.deleteRecords(entity: .category, with: predicate)
            switch result{
            case .success(_):
                deletedNames.append(name)
                dispatchGroup.leave()
            case .failure(let error):
                presenter?.result(result: .failure(error))
                dispatchGroup.leave()
            case .none:
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.presenter?.result(result: .success(.successfullyDeleted(deletedNames)))
        }
    }
}
