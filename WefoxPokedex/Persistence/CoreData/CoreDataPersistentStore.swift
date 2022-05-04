//
//  CoreDataPersistentStore.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/4/22.
//

import Combine
import CoreData

protocol CoreDataPersistentStore: PersistentStore {
    func insert<T>(_ object: T) -> AnyPublisher<T, PersistentError> where T: NSManagedObject
    func count<T>(_ fetchRequest: NSFetchRequest<T>) -> AnyPublisher<Int, PersistentError> where T : NSFetchRequestResult
}
