//
//  HTTPMethod.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/4/22.
//

import Foundation

enum HTTPMethod: String, Equatable {
    case get = "GET"
    case post = "POST"
    
    var name: String { rawValue }
}
