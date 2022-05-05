//
//  NSManagedObjectContext++Utils.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/4/22.
//

import CoreData

extension NSManagedObjectContext {
    
    func safeObject<T>(with objectID: NSManagedObjectID) throws -> T where T: NSManagedObject {
        guard let object = object(with: objectID) as? T else { throw PersistentError.coreDataError(reason:.objectCastFailed) }
        if object.isFault { throw PersistentError.coreDataError(reason:.objectNotFound) }
        return object
    }
    
    func perform(_ safeClosure: @escaping (Result<NSManagedObjectContext,PersistentError>) -> Void) {
        self.perform { [weak self] in
            guard let strongSelf = self else { safeClosure(.failure(PersistentError.coreDataError(reason: .contextFoundNil))); return }
            safeClosure(.success(strongSelf))
        }
    }
    
    func performAndWait(_ safeClosure: (Result<NSManagedObjectContext,PersistentError>) -> Void) {
        self.performAndWait { [weak self] in
            guard let strongSelf = self else { safeClosure(.failure(PersistentError.coreDataError(reason: .contextFoundNil))); return }
            safeClosure(.success(strongSelf))
        }
    }
}
