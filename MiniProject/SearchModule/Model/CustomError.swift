//
//  CustomError.swift
//  MiniProject
//
//  Created by reyhan muhammad on 16/08/23.
//

import Foundation

enum CustomError: String, Error{
    case callApiFailBecauseURLNotFound
    case apiReturnNoData
    case somethingWentWrong
    case fetchFromCoreDataError
    case failedToLoadJson
    case dataAlreadyExist
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .dataAlreadyExist:
            return NSLocalizedString("Data already exist", comment: "Display this eror when user already have saved that category previously")
        default:
            return NSLocalizedString("Something went wrong", comment: "Something unexpected occured")

        }
    }
}
