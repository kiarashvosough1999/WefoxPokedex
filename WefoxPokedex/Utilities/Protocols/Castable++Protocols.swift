//
//  Castable++Protocols.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/4/22.
//

import Foundation

infix operator ->>: DefaultPrecedence

public protocol Castable {
    
    func forceCast<U>(to type: U.Type) -> U
    
    func AS<U>(to type: U.Type) -> U?
    
    func AS<U>() -> U?
    
    func cast<U>(to type: U.Type) -> U?
    
    func cast<U>() -> U?
    
    func unsafeBitCast<U>(to type: U.Type) throws -> U
    
    func unsafeDownCast<U>(to type: U.Type) throws -> U where U: AnyObject
    
    static func ->> <U>(lhs: Self, rhs: U.Type) -> U?
    
}

public extension Castable where Self: AnyObject {
    
    func unsafeDownCast<U>(to type: U.Type) throws -> U where U: AnyObject {
        Swift.unsafeDowncast(self, to: type.self)
    }
}

public extension Castable {
    
    func isReferenceType() -> Bool {
        return Swift.type(of: self) is AnyClass
    }
    
    static func ->> <U>(lhs: Self, rhs: U.Type) -> U? {
        lhs as? U
    }
    
    func forceCast<U>(to type: U.Type) -> U {
        self as! U
    }
    
    func AS<U>(to type: U.Type) -> U? {
        self as? U
    }
    
    func AS<U>() -> U? {
        self.AS(to: U.self)
    }
    
    func cast<U>(to type: U.Type) -> U? {
        self as? U
    }
    
    func cast<U>() -> U? {
        self.cast(to: U.self)
    }
    
    func unsafeBitCast<U>(to type: U.Type) throws -> U {
        if MemoryLayout<Self>.size != MemoryLayout<U>.size {
            throw CastableError.bitcastTwoVariableWithDifferentBitCount
        }
        
        return Swift.unsafeBitCast(self, to: U.self)
    }
    
    func unsafeDownCast<U>(to type: U.Type) throws -> U where U: AnyObject {
        throw CastableError.downCastingNonRefrencableVariable
    }
}

public enum CastableError: Error {
    
    case bitcastTwoVariableWithDifferentBitCount
    case downCastingNonRefrencableVariable
}

extension NSObject: Castable {
    public func unsafeDownCast<U>(to type: U.Type) throws -> U where U: AnyObject {
        unsafeDowncast(self, to: type)
    }
}
