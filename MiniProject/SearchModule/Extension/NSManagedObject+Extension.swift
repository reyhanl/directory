//
//  NSManagedObject+Extension.swift
//  MiniProject
//
//  Created by reyhan muhammad on 14/08/23.
//

import CoreData

extension NSManagedObject{
    var dict: [String:Any]{
        let keys = Array(self.entity.attributesByName.keys)
        let dict = self.dictionaryWithValues(forKeys: keys)
        return dict
    }
}
