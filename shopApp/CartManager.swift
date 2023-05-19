//
//  CartManager.swift
//  shopApp
//
//  Created by Pierrick Catalo on 2023-05-18.
//

import Foundation

class CartManager : ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var total: Int = 0
    
    func addToCart(product: Product) {
        products.append(Product(name: product.name, image: product.image, price: product.price))
        total += product.price
    }
    
    func removeFromCart(product: Product){
        // filter out removed product from products
        products = products.filter { $0.id != product.id }
        total -= product.price
    }
}
