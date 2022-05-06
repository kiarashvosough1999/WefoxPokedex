//
//  PokemoneDetailModel++Mocks.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/6/22.
//

import Foundation
@testable import WefoxPokedex

extension PokemoneDetailModel {
    static var mocks: [PokemoneDetailModel] {
        [
            PokemoneDetailModel(baseExperience: 31,
                                height: 12,
                                id: 12,
                                name: "Test 1",
                                imageData: TestImage1().pngData!,
                                types: "water proof",
                                weight: 213,
                                catchedDate: Date()),
            PokemoneDetailModel(baseExperience: 4,
                                height: 122,
                                id: 32,
                                name: "Test 2",
                                imageData: TestImage1().pngData!,
                                types: "water proof3",
                                weight: 213,
                                catchedDate: Date()),
            PokemoneDetailModel(baseExperience: 31,
                                height: 8,
                                id: 87,
                                name: "Test 3",
                                imageData: TestImage1().pngData!,
                                types: "water proof2",
                                weight: 902,
                                catchedDate: Date()),
        ]
    }
}
