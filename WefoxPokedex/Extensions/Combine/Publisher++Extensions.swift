//
//  Publisher++Extensions.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

import Combine
import Foundation

extension Publisher {
    func sinkToResult(_ result: @escaping (Result<Output, Failure>) -> Void) -> AnyCancellable {
        return sink { completion in
            switch completion {
            case let .failure(error): result(.failure(error))
            default: break
            }
        } receiveValue: { value in
            result(.success(value))
        }
    }
    
    func extractUnderlyingError() -> Publishers.MapError<Self, Failure> {
        mapError {
            ($0.underlyingError as? Failure) ?? $0
        }
    }

    func ensureTimeSpan(_ interval: TimeInterval) -> AnyPublisher<Output, Failure> {
        let timer = Just<Void>(())
            .delay(for: .seconds(interval), scheduler: RunLoop.main)
            .setFailureType(to: Failure.self)
        return zip(timer)
            .map { $0.0 }
            .eraseToAnyPublisher()
    }
}

private extension Error {
    var underlyingError: Error? {
        let nsError = self as NSError
        // "The Internet connection appears to be offline."
        if nsError.domain == NSURLErrorDomain && nsError.code == -1009 {
            return self
        }
        return nsError.userInfo[NSUnderlyingErrorKey] as? Error
    }
}

extension Publisher where Failure == Never {
    func weakAssign<T: AnyObject>(to keyPath: ReferenceWritableKeyPath<T, Output>, on object: T) -> AnyCancellable {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}
