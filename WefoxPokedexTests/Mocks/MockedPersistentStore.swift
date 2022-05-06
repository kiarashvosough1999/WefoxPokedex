//
//  MockedPersistentStore.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/5/22.
//

import CoreData
import Combine
@testable import WefoxPokedex

final class MockedPersistentStore: Mock, CoreDataPersistentStore {
    
    struct ContextSnapshot: Equatable {
        let inserted: Int
        let updated: Int
        let deleted: Int
    }
    
    enum Action: Equatable {
        case count
        case objectPublisher(publishedObjectCount: Int)
        case fetchOne(ContextSnapshot)
        case insert(ContextSnapshot)
    }
    
    var actions = MockActions<Action>(expected: [])
    
    var countResult: Int = 0
    
    // MARK: - LifeCycle
    
    deinit {
        destroyDatabase()
    }
    
    // MARK: - count
    
    func count<T>(_ fetchRequest: NSFetchRequest<T>) -> AnyPublisher<Int, PersistentError> where T : NSFetchRequestResult {
        do {
            let context = container.viewContext
            context.reset()
            let result = try context.count(for: fetchRequest)
            register(.count)
            return Just<Int>.withErrorType(result, PersistentError.self).publish()
        } catch {
            return Fail<Int, PersistentError>(error: .coreDataError(reason: .CannotFetch)).publish()
        }
    }
    
    // MARK: - fetch
    
    func fetchOne<T>(_ fetchRequest: NSFetchRequest<T>) -> AnyPublisher<T, PersistentError> where T : NSFetchRequestResult {
        do {
            let context = container.viewContext
            context.reset()
            if let result = try context.fetch(fetchRequest).first {
                register(.fetchOne(context.snapshot))
                return Just<T>.withErrorType(result, PersistentError.self).publish()
            }
            return Fail<T, PersistentError>(error: .coreDataError(reason: .CannotFindObject)).publish()
        } catch {
            return Fail<T, PersistentError>(error: .coreDataError(reason: .CannotFetch)).publish()
        }
    }
    
    // MARK: - insert
    
    func insert<T>(_ object: T.Type, mutator: @escaping ObjectMutator<T>) -> AnyPublisher<T, PersistentError> where T : NSManagedObject {
        do {
            let context = container.viewContext
            context.reset()
            let object = T(context: context)
            mutator(object)
            register(.insert(context.snapshot))
            try context.save()
            return Just(object).setFailureType(to: PersistentError.self).publish()
        } catch {
            return Fail<T, PersistentError>(error: .coreDataError(reason: .CannotSave)).publish()
        }
    }
    
    // MARK: - publisher
    
    func objectPublisher<T>(fetchRequest: NSFetchRequest<T>) -> AnyPublisher<[T], Error> where T : NSFetchRequestResult {
        do {
            let context = container.viewContext
            let objects = try context.fetch(fetchRequest)
            register(.objectPublisher(publishedObjectCount: objects.count))
            try context.save()
            return Just(objects).setFailureType(to: Error.self).publish()
        } catch {
            return Fail<[T], Error>(error: PersistentError.coreDataError(reason: .CannotFetch)).publish()
        }
    }
    
    // MARK: -
    
    func preloadData(_ preload: (NSManagedObjectContext) throws -> Void) throws {
        try preload(container.viewContext)
        if container.viewContext.hasChanges {
            try container.viewContext.save()
        }
        container.viewContext.reset()
    }
    
    // MARK: - Database
    
    private let dbVersion = CoreDataStack.Version(CoreDataStack.Version.actual)
    
    private var dbURL: URL {
        guard let url = dbVersion.dbFileURL(.cachesDirectory, .userDomainMask)
        else { fatalError() }
        return url
    }
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: dbVersion.modelName)
        
        let persistentStoredescription = NSPersistentStoreDescription()
        persistentStoredescription.type = NSInMemoryStoreType
        
        container.persistentStoreDescriptions = [persistentStoredescription]
        let group = DispatchGroup()
        group.enter()
        container.loadPersistentStores { (desc, error) in
            if let error = error {
                fatalError("\(error)")
            }
            group.leave()
        }
        group.wait()
        container.viewContext.mergePolicy = NSOverwriteMergePolicy
        container.viewContext.undoManager = nil
        return container
    }()
    
    private func destroyDatabase() {
//        try? container.persistentStoreCoordinator
//            .destroyPersistentStore(at: dbURL, ofType: NSInMemoryStoreType, options: nil)
//        try? FileManager().removeItem(at: dbURL)
    }
}

extension NSManagedObjectContext {
    var snapshot: MockedPersistentStore.ContextSnapshot {
        .init(inserted: insertedObjects.count,
              updated: updatedObjects.count,
              deleted: deletedObjects.count)
    }
}
