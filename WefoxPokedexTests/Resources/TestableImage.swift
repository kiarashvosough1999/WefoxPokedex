//
//  TesableImage.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/6/22.
//

import UIKit

protocol TesableImage {
    var name: String { get }
    var pngData: Data? { get }
}

struct TestImage1: TesableImage {
    
    var name: String { "empty_image_placeholder_img" }
    
    var pngData: Data? { UIImage(named: name)?.pngData() }
}
