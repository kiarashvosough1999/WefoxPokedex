//
//  CoreDataPersistentStore.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/4/22.
//

import Combine
import CoreData

protocol CoreDataPersistentStore: PersistentStore {
    
    typealias ObjectMutator<T: AnyObject> = (T) -> Void
    
    func insert<T>(_ object: T.Type, mutator: @escaping ObjectMutator<T>) -> AnyPublisher<T, PersistentError> where T: NSManagedObject

    func count<T>(_ fetchRequest: NSFetchRequest<T>) -> AnyPublisher<Int, PersistentError> where T : NSFetchRequestResult
    
    func objectPublisher<T>(fetchRequest: NSFetchRequest<T>) -> AnyPublisher<[T],Error> where T : NSFetchRequestResult
    
    func fetchOne<T>(_ fetchRequest: NSFetchRequest<T>) -> AnyPublisher<T, PersistentError> where T : NSFetchRequestResult
}
