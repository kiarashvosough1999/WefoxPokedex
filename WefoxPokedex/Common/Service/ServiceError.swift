//
//  ServiceError.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/4/22.
//

import Foundation

enum ServiceError: Error {
    case appInternalError(description: String)
}
