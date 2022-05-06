//
//  PokemoneDetailModel.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/5/22.
//

import Foundation

struct PokemoneDetailModel: Equatable, Identifiable {

    let baseExperience: Int32
    let height: Int32
    let id: Int32
    let name: String
    let imageData: Data
    let types: String
    let weight: Int32
    let catchedDate: Date
    
    init(baseExperience: Int32,
         height: Int32,
         id: Int32,
         name: String,
         imageData: Data,
         types: String,
         weight: Int32,
         catchedDate: Date) {
        self.baseExperience = baseExperience
        self.height = height
        self.id = id
        self.name = name
        self.imageData = imageData
        self.types = types
        self.weight = weight
        self.catchedDate = catchedDate
    }
}
