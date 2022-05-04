//
//  PersistentError.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/4/22.
//

import Foundation


// MARK: Errors

enum PersistentError: Error {
    
    case selfFoundNil
    case coreDataError(reason: CoreDataError)
    
    enum CoreDataError: Error {
        case ValuesFoundNil(propertyNames:[String] = [])
        case CannotCreateFromModel
        case CannotCreate
        case CannotFindObject
        case WriteContextNotExist
        case ReadContextNotExist
        case ContextNameNotFound(name: String)
        case ContextNotFound(name: String)
        case contextFoundNil
        case objectNotFound
        case objectCastFailed
        case ContextDealocated
        case CannotFetch
        case CannotFetchInObserveMode
        case CannotDelete
        case CannotSave
        case CannotUpdate
        case CannotMap
        case canNotFetchCount
        case CannotSetRelationShip
        case InvalidObjectID(String)
        case unknown(Error?)
        case persistenObjectNameDoesNotExist(name: String)
        
    }
}

extension Error {
    
    var asFPError: PersistentError? {
        self as? PersistentError
    }
    
    var asFPErrorUnsafe: PersistentError {
        self as! PersistentError
    }

    func asFieldError(orFailWith message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) -> PersistentError {
        guard let anyError = self as? PersistentError else {
            fatalError(message(), file: file, line: line)
        }
        return anyError
    }

    func asFPError(or defaultAFError: @autoclosure () -> PersistentError) -> PersistentError {
        self as? PersistentError ?? defaultAFError()
    }
}
