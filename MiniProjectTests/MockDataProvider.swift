import Foundation


class MockDataProvider{
    static func getDummyCategories() -> [Category]{
        if let path = Bundle.main.path(forResource: "dummy", ofType: "json"){
            do{
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                
                let decoder = JSONDecoder()
                let model = try decoder.decode(ModelContainer.self, from: data)
                return model.data?.categories ?? []
                
            }catch{
                print("error: \(error.localizedDescription)")
            }
        }else{
            print("error: path does not exist")
        }
        return []
    }
    
    static func getThirdLevelCategories() -> [Category]{
        if let path = Bundle.main.path(forResource: "dummy", ofType: "json"){
            do{
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                
                let decoder = JSONDecoder()
                let model = try decoder.decode(ModelContainer.self, from: data)
                guard let categories = model.data?.categories else{return []}
                var result: [Category] = []
                for category in categories {
                    let tempCategories = getAllTheNLevelCategories(current: 1, targetLevel: 3, category: category) //get all the grandchildren of that category
                    result.append(contentsOf: tempCategories)
                }
                print(result)
                return result
                
            }catch{
                print("error: \(error.localizedDescription)")
            }
        }else{
            print("error: path does not exist")
        }
        return []
    }
    
    static func getAllTheCategories(category: Category) -> [Category]{
        var categories: [Category] = []
        let temp = category.child
        for tempCategory in temp ?? [] {
            categories.append(tempCategory)
            let sublevelCategories = getAllTheCategories(category: tempCategory)
            categories.append(contentsOf: sublevelCategories)
        }
        
        return categories
    }
    
    static func getAllTheNLevelCategories(current level: Int, targetLevel: Int, category: Category) -> [Category]{
        var categories: [Category] = []
        let temp = category.child
        if level == targetLevel{
            categories.append(category)
        }
        for tempCategory in temp ?? [] {
            let sublevelCategories = getAllTheNLevelCategories(current: level + 1, targetLevel: targetLevel, category: tempCategory)
            categories.append(contentsOf: sublevelCategories)
        }
        
        return categories
    }

}
