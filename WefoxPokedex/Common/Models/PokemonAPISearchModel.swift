//
//  PokemonAPISearchModel.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

import Foundation

struct PokemonAPISearchModel: Codable {
    
    let baseExperience: Int32
    let height: Int32
    let id: Int32
    let name: String
    let order: Int32
    let sprites: Sprites
    let types: [TypeElement]
    let weight: Int32

    enum CodingKeys: String, CodingKey {
        case baseExperience = "base_experience"
        case height
        case id
        case order
        case sprites, types, weight, name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.baseExperience = try container.decode(Int32.self, forKey: .baseExperience)
        self.height = try container.decode(Int32.self, forKey: .height)
        self.id = try container.decode(Int32.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.order = try container.decode(Int32.self, forKey: .order)
        self.sprites = try container.decode(Sprites.self, forKey: .sprites)
        self.types = try container.decode([TypeElement].self, forKey: .types)
        self.weight = try container.decode(Int32.self, forKey: .weight)
    }
    
    init(baseExperience: Int32, height: Int32, id: Int32, name: String, order: Int32, sprites: Sprites, types: [TypeElement], weight: Int32) {
        self.baseExperience = baseExperience
        self.height = height
        self.id = id
        self.name = name
        self.order = order
        self.sprites = sprites
        self.types = types
        self.weight = weight
    }
}


// MARK: - Sprites

class Sprites: Codable {
    
    let frontDefault: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
    
    init(frontDefault: String) {
        self.frontDefault = frontDefault
    }
}

// MARK: - TypeElement

struct TypeElement: Codable {

    let slot: Int
    let type: Species
    
    init(slot: Int, type: Species) {
        self.slot = slot
        self.type = type
    }
}

// MARK: - Species

struct Species: Codable {

    let name: String
    
    init(name: String) {
        self.name = name
    }
}
