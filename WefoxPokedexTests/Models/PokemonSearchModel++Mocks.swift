//
//  PokemonSearchModel++Mocks.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/6/22.
//

@testable import WefoxPokedex

extension PokemonSearchModel {
    
    static var mocksWithoutImageURL: [PokemonSearchModel] {
        [
            PokemonSearchModel(baseExperience: 32,
                               height: 434,
                               id: 23,
                               name: "test1",
                               order: 89,
                               frontDefault : "",
                               types: "water proof",
                               weight: 686),
        ]
    }
    
    static var mocks: [PokemonSearchModel] {
        [
            PokemonSearchModel(baseExperience: 32,
                               height: 434,
                               id: 23,
                               name: "test1",
                               order: 89,
                               frontDefault : "test.com/test1.png",
                               types: "water proof",
                               weight: 686),
            PokemonSearchModel(baseExperience: 21,
                               height: 343,
                               id: 134,
                               name: "test2",
                               order: 33,
                               frontDefault : "test.com/test2.png",
                               types: "iron proof",
                               weight: 232),
            PokemonSearchModel(baseExperience: 31,
                               height: 849,
                               id: 93,
                               name: "test1",
                               order: 37,
                               frontDefault : "test.com/test3.png",
                               types: "air proof",
                               weight: 782)
        ]
    }
}
