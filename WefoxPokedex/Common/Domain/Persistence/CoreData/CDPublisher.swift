//
//  CDPublisher.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/5/22.
//

import Combine
import CoreData
import Foundation

class CDPublisher<Entity>: Publisher where Entity: NSFetchRequestResult {

    typealias Output = [Entity]
    typealias Failure = Error
    
    private let subject: CurrentValueSubject<[Entity], Failure>
    private var fetchResultController: NSFetchedResultsController<Entity>?
    
    private var coordinator: FetchResultControllerDelegateCoordinator?
    
    private var subscriptions: Int = 0
    
    private var safeSubscription: Int {
        get {
            return subscriptions
        }
        set {
            queue.sync(flags: .barrier) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.subscriptions = newValue
            }
        }
    }
    private let queue = DispatchQueue(label: "CDPublisher..queue.", attributes: .concurrent)
    
    init(fetchResultController: NSFetchedResultsController<Entity>) {
        self.fetchResultController = fetchResultController
        self.subject = CurrentValueSubject([])
        self.coordinator = FetchResultControllerDelegateCoordinator(objectEmitterSubject: subject)
    }
    
    func receive<S>(subscriber: S) where S: Subscriber, CDPublisher.Failure == S.Failure, CDPublisher.Output == S.Input {
        
        safeSubscription += 1
        
        if safeSubscription == 1 {
            fetchResultController?.delegate = coordinator
            do {
                try fetchResultController?.performFetch()
                let result = fetchResultController?.fetchedObjects ?? []
                subject.send(result)
            } catch {
                subject.send(completion: .failure(error))
            }
        }
        let subscription = CDSubscription<S>(fetchPublisher: self)
        subscription.target = subscriber
        subscriber.receive(subscription: subscription)
        subscription.startSubscription()
    }
    
    private func dropSubscription() {
        safeSubscription -= 1
        if safeSubscription == 0 {
            fetchResultController?.delegate = .none
            coordinator = .none
            fetchResultController = .none
        }
    }
}

// MARK: - CDSubscription
extension CDPublisher {
    
    private class CDSubscription<Target: Subscriber>: Subscription where Target.Failure == Failure, Target.Input == Output {
        
        private var fetchPublisher: CDPublisher?
        private var cancellable: AnyCancellable?
        fileprivate var target: Target?
        
        init(fetchPublisher: CDPublisher) {
            self.fetchPublisher = fetchPublisher
        }
        
        fileprivate func startSubscription() {
            cancellable = fetchPublisher?.subject.sink { completion in
                self.target?.receive(completion: completion)
            } receiveValue: { value in
                _ = self.target?.receive(value)
            }
        }
        
        func request(_ demand: Subscribers.Demand) {}
        
        func cancel() {
            cancellable?.cancel()
            cancellable = .none
            fetchPublisher?.dropSubscription()
            fetchPublisher = .none
        }
    }
}

// MARK: - FetchResultControllerDelegateCoordinator

extension CDPublisher {
    
    final private class FetchResultControllerDelegateCoordinator: NSObject, NSFetchedResultsControllerDelegate {

        private weak var objectEmitterSubject: CurrentValueSubject<[Entity], Failure>?
        
        fileprivate init(objectEmitterSubject: CurrentValueSubject<[Entity], Failure>) {
            self.objectEmitterSubject = objectEmitterSubject
        }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            guard let fetchedObjects = controller.fetchedObjects as? [Entity] else {
                return
            }
            objectEmitterSubject?.send(fetchedObjects)
        }
    }
}
