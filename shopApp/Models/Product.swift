//
//  Product.swift
//  shopApp
//
//  Created by Pierrick Catalo on 2023-05-18.
//

import Foundation

struct Product: Identifiable {
    var id = UUID()
    var name: String
    var image: String
    var price: Int
}

var productList = [Product(name: "Camera", image: "camera", price: 1350),
                   Product(name: "Controller", image: "controller", price: 90),
                   Product(name: "Headphones", image: "headphones", price: 380),
                   Product(name: "Laptop", image: "laptop", price: 2600),
                   Product(name: "Smartphone", image: "smartphone", price: 1490),
                   Product(name: "Speakers", image: "speakers", price: 400),
                   Product(name: "TV", image: "tv", price: 430),
                   Product(name: "Watch", image: "watch", price: 660)]
