//
//  NSManagedObjectContext++Extensions.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

import CoreData

extension NSManagedObjectContext {
    
    func configureAsReadOnlyContext() {
        automaticallyMergesChangesFromParent = true
        mergePolicy = NSRollbackMergePolicy
        undoManager = nil
        shouldDeleteInaccessibleFaults = true
    }
}
