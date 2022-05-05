//
//  PokemonBagListModel.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/5/22.
//

import Foundation

struct PokemonBagListModel: Equatable, Identifiable {

    let baseExperience: Int32
    let height: Int32
    let id: Int32
    let name: String
    let order: Int32
    let imageData: Data
    let types: String
    let weight: Int32
    
    init(baseExperience: Int32,
         height: Int32,
         id: Int32,
         name: String,
         order: Int32,
         imageData: Data,
         types: String,
         weight: Int32) {
        self.baseExperience = baseExperience
        self.height = height
        self.id = id
        self.name = name
        self.order = order
        self.imageData = imageData
        self.types = types
        self.weight = weight
    }
}
