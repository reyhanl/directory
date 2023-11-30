//
//  MockMainInteractor.swift
//  MiniProjectUITests
//
//  Created by reyhan muhammad on 16/08/23.
//

import Foundation

class MockMainInteractor: MainPresenterToInteractorProtocol{
    var presenter: MainInteractorToPresenterProtocol?
    var categories: [Category]?
    
    init(withData: Bool){
        if withData{
            self.categories = MockDataProvider.getThirdLevelCategories()
        }
    }
    
    func fetchData() {
        if let categories = categories{
            presenter?.result(result: .success(.successfullyRetrieveData(categories)))
        }else{
            presenter?.result(result: .failure(CustomError.fetchFromCoreDataError))
        }
    }
    
    func userSaveCategory(category: Category) {
        
    }
    
    func userDeleteSavedCategory(with names: [String]) {
        presenter?.result(result: .success(.successfullyDeleted(names)))
    }
    
    func loadFromJSON<T: Decodable>(fileName: String, _ type: T.Type) -> T?{
        if let path = Bundle.main.path(forResource: fileName, ofType: "json"){
            do{
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                
                let decoder = JSONDecoder()
                let model = try decoder.decode(T.self, from: data)
                return model
                
            }catch{
                print("error: \(error.localizedDescription)")
            }
        }else{
            print("error: path does not exist")
        }
        return nil
    }
}
