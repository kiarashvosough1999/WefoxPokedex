//
//  PokemonBagListModel++Mocks.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/6/22.
//

@testable import WefoxPokedex

extension PokemonBagListModel {
    
    static var mocks: [PokemonBagListModel] {
        [
            PokemonBagListModel(baseExperience: 31,
                                height: 12,
                                id: 12,
                                name: "Test 1",
                                order: 32,
                                imageData: TestImage1().pngData!,
                                types: "water proof",
                                weight: 213),
            PokemonBagListModel(baseExperience: 4,
                                height: 122,
                                id: 32,
                                name: "Test 2",
                                order: 32,
                                imageData: TestImage1().pngData!,
                                types: "water proof3",
                                weight: 213),
            PokemonBagListModel(baseExperience: 31,
                                height: 8,
                                id: 87,
                                name: "Test 3",
                                order: 73,
                                imageData: TestImage1().pngData!,
                                types: "water proof2",
                                weight: 902),
        ]
    }
}
