//
//  CartView.swift
//  shopApp
//
//  Created by Pierrick Catalo on 2023-05-18.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    
    var body: some View {
        ScrollView {
            content
        }
        .navigationTitle("My Cart")
        .padding(.top)
        .onDisappear {
            cartManager.paymentSuccess = false
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if cartManager.paymentSuccess {
            Text("Thanks for your purchase! You'll also receive an email confirmation shortly.")
                .padding()
        } else if cartManager.products.isEmpty {
            Text("Your cart is empty")
        } else {
            cartContent
        }
    }
    
    private var cartContent: some View {
        VStack(spacing: 16) {
            ForEach(cartManager.products, id: \.id) { product in
                ProductRow(product: product)
            }
            
            HStack {
                Text("Your cart total is")
                Spacer()
                Text("$\(cartManager.total).00")
                    .bold()
            }
            .padding()
            
            PaymentButton(action: cartManager.pay)
                .padding()
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
            .environmentObject(CartManager())
    }
}
