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
    
    func toPokemonSearchModel() -> PokemonSearchModel {
        PokemonSearchModel(baseExperience: self.baseExperience,
                           height: self.height,
                           id: self.id,
                           name: self.name,
                           order: self.order,
                           frontDefault: self.sprites.frontDefault,
                           types: self.types.map(\.type.name),
                           weight: self.weight)
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
