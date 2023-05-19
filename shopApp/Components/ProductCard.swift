//
//  ProductCard.swift
//  shopApp
//
//  Created by Pierrick Catalo on 2023-05-18.
//

import SwiftUI

struct ProductCard: View {
    @EnvironmentObject var cartManager: CartManager
    var product: Product
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 0) {
                Image(product.image)
                    .resizable()
                
                VStack(alignment: .leading) {
                    Text(product.name)
                        .bold()
                    
                    Text("$\(product.price)")
                        .font(.caption)
                }
                .padding()
                .frame(width: 180, alignment: .leading)
                .background(.ultraThinMaterial)
            }
            .cornerRadius(20)
            .frame(width: 180, height: 250)
            .shadow(radius: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black, lineWidth: 1)
            )
            
            Button {
                cartManager.addToCart(product: product)
            } label: {
                Image(systemName: "plus")
                    .padding(10)
                    .foregroundColor(.white)
                    .background(.black)
                    .cornerRadius(50)
                    .padding(5)
            }
        }
    }
}

struct ProductCard_Previews: PreviewProvider {
    static var previews: some View {
        ProductCard(product: productList[7])
            .environmentObject(CartManager())
    }
}
