//
//  PokemonAPISearchModel++Mocks.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/5/22.
//

@testable import WefoxPokedex

extension PokemonAPISearchModel {
    
    static var mocks: [PokemonAPISearchModel] {
        [
            PokemonAPISearchModel(baseExperience: 32,
                                  height: 434,
                                  id: 23,
                                  name: "test1",
                                  order: 89,
                                  sprites: .init(frontDefault: "test.test.com/test.png"),
                                  types: [.init(slot: 8, type: .init(name: "water proof"))],
                                  weight: 686),
            PokemonAPISearchModel(baseExperience: 21,
                                  height: 343,
                                  id: 134,
                                  name: "test2",
                                  order: 33,
                                  sprites: .init(frontDefault: "test.test.com/test2.png"),
                                  types: [.init(slot: 27, type: .init(name: "iron proof"))],
                                  weight: 232),
            PokemonAPISearchModel(baseExperience: 31,
                                  height: 849,
                                  id: 93,
                                  name: "test1",
                                  order: 37,
                                  sprites: .init(frontDefault: "test.test.com/test.png"),
                                  types: [.init(slot: 251, type: .init(name: "air proof"))],
                                  weight: 782)
        ]
    }
}
