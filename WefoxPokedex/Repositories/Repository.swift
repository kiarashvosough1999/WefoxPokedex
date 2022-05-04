//
//  Repository.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/4/22.
//

import Foundation

protocol Repository {
    func mapPersistentDoimanErrors(error: PersistentError) -> ServiceError
}

extension Repository {
    
    func mapPersistentDoimanErrors(error: PersistentError) -> ServiceError {
        switch error {
        case .coreDataError:
            return .appInternalError(description: "For some rrason we cant procces your demand")
        }
    }
}
