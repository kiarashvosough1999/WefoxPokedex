//
//  PokemonSearchModel.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

import Foundation

struct PokemonSearchModel: Codable {
    let baseExperience: Int
    let height: Int
    let id: Int
    let name: String
    let order: Int
    let sprites: Sprites
    let types: [TypeElement]
    let weight: Int

    enum CodingKeys: String, CodingKey {
        case baseExperience = "base_experience"
        case height
        case id
        case order
        case sprites, types, weight, name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.baseExperience = try container.decode(Int.self, forKey: .baseExperience)
        self.height = try container.decode(Int.self, forKey: .height)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.order = try container.decode(Int.self, forKey: .order)
        self.sprites = try container.decode(Sprites.self, forKey: .sprites)
        self.types = try container.decode([TypeElement].self, forKey: .types)
        self.weight = try container.decode(Int.self, forKey: .weight)
    }
}


// MARK: - Sprites

class Sprites: Codable {

    let frontDefault: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

// MARK: - TypeElement

struct TypeElement: Codable {
    let slot: Int
    let type: Species
}

// MARK: - Species

struct Species: Codable {
    let name: String
}
