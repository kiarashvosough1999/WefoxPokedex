//
//  PokemonSearchResult.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/4/22.
//

import Foundation

struct PokemonSearchModel: Equatable {
    
    let baseExperience: Int32
    let height: Int32
    let id: Int32
    let name: String
    let order: Int32
    let frontDefault: String
    let types: [String]
    let weight: Int32
    
    var imageURL: URL? {
        URL(string: frontDefault)
    }
    
    init(baseExperience: Int32,
         height: Int32,
         id: Int32,
         name: String,
         order: Int32,
         frontDefault: String,
         types: [String],
         weight: Int32) {
        self.baseExperience = baseExperience
        self.height = height
        self.id = id
        self.name = name
        self.order = order
        self.frontDefault = frontDefault
        self.types = types
        self.weight = weight
    }
    
    init(baseExperience: Int32,
         height: Int32,
         id: Int32,
         name: String,
         order: Int32,
         frontDefault: String,
         types: String,
         weight: Int32) {
        self.baseExperience = baseExperience
        self.height = height
        self.id = id
        self.name = name
        self.order = order
        self.frontDefault = frontDefault
        self.types = types.split(separator: ",").map { String($0) }
        self.weight = weight
    }
    
    var joindTypes: String {
        types.joined(separator: ",")
    }
}

enum PokemonSearchResult: Equatable {
    case new(model: PokemonSearchModel)
    case alreadyPicked(model: PokemonSearchModel)
    
    var model: PokemonSearchModel {
        switch self {
        case .new(let model):
            return model
        case .alreadyPicked(let model):
            return model
        }
    }
}
