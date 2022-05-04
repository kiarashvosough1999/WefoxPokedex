//
//  CoreDataStack.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

import CoreData
import Combine

struct CoreDataStack: CoreDataPersistentStore {
    
    private let container: NSPersistentContainer
    private let isStoreLoaded = CurrentValueSubject<Bool, Error>(false)
    private let bgQueue = DispatchQueue(label: "coredata")
    
    init(directory: FileManager.SearchPathDirectory = .documentDirectory,
         domainMask: FileManager.SearchPathDomainMask = .userDomainMask,
         version vNumber: UInt) {
        let version = Version(vNumber)
        container = NSPersistentContainer(name: version.modelName)
        if let url = version.dbFileURL(directory, domainMask) {
            let store = NSPersistentStoreDescription(url: url)
            container.persistentStoreDescriptions = [store]
        }
        bgQueue.async { [weak isStoreLoaded, weak container] in
            container?.loadPersistentStores { (storeDescription, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        isStoreLoaded?.send(completion: .failure(error))
                    } else {
                        container?.viewContext.configureAsReadOnlyContext()
                        isStoreLoaded?.value = true
                    }
                }
            }
        }
    }
    
    // I did not impelement background context as it may required more time to implement and handle the changes
    // the whole project use main context, although it is not the rigth way
    var currentMainContext: NSManagedObjectContext {
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.undoManager = nil
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return container.viewContext
    }
    
    private var onStoreIsReady: AnyPublisher<Void, Error> {
        return isStoreLoaded
            .filter { $0 }
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
}

// MARK: - Insert

extension CoreDataStack {

    func insert<T>(_ object: T) -> AnyPublisher<T, PersistentError> where T: NSManagedObject {
        Deferred {
            Future { promise in
                self.currentMainContext.perform { safeContext in
                    
                    guard let context = try? safeContext.get() else {
                        promise(.failure(.coreDataError(reason: .ContextDealocated)))
                        return
                    }

                    do {
                        let managedObject = T(context: context)
                        try context.save()
                        promise(.success(managedObject))
                    } catch {
                        promise(.failure(.coreDataError(reason: .CannotSave)))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
}

// MARK: - Count

extension CoreDataStack {

    func count<T>(_ fetchRequest: NSFetchRequest<T>) -> AnyPublisher<Int, PersistentError> where T : NSFetchRequestResult {
        Deferred {
            Future<Int,PersistentError> { promise in
                
                self.currentMainContext.perform { safeContext in
                    guard let context = try? safeContext.get() else {
                        promise(.failure(.coreDataError(reason: .ContextDealocated)))
                        return
                    }
                    
                    do {
                        let count = try context.count(for: fetchRequest)
                        promise(.success(count))
                    } catch {
                        promise(.failure(.coreDataError(reason: .canNotFetchCount)))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Versioning

extension CoreDataStack.Version {
    static var actual: UInt { 1 }
}
