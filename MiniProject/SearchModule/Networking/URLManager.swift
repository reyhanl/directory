//
//  URLManager.swift
//  MiniProject
//
//  Created by reyhan muhammad on 12/08/23.
//

import Foundation

enum URLManager{
    case baseUrl
    case getAllCategoriess
    var url: String{
        switch self{
        case .baseUrl:
            return "hades.tokopedia.com/"
        case .getAllCategoriess:
            return "category/v1/tree/all"
        }
    }
}
