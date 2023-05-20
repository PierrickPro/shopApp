//
//  PaymentHandler.swift
//  shopApp
//
//  Created by Pierrick Catalo on 2023-05-19.
//

import Foundation
import PassKit

typealias PaymentCompletionHandler = (Bool) -> Void

class PaymentHandler: NSObject, PKPaymentAuthorizationControllerDelegate {
    var paymentController: PKPaymentAuthorizationController?
    var paymentSummaryItems = [PKPaymentSummaryItem]()
    var paymentStatus = PKPaymentAuthorizationStatus.failure
    var completionHandler: PaymentCompletionHandler?
    
    static let supportedNetworks: [PKPaymentNetwork] = [
        .visa,
        .masterCard,
        .interac
    ]
    
    func shippingMethodCalculator() -> [PKShippingMethod] {
        let today = Date()
        guard let shippingStart = Calendar.current.date(byAdding: .day, value: 5, to: today),
              let shippingEnd = Calendar.current.date(byAdding: .day, value: 10, to: today) else {
            return []
        }
        
        let startComponents = Calendar.current.dateComponents([.calendar, .year, .month, .day], from: shippingStart)
        let endComponents = Calendar.current.dateComponents([.calendar, .year, .month, .day], from: shippingEnd)
        
        let shippingDelivery = PKShippingMethod(label: "Delivery", amount: NSDecimalNumber(string: "0.00"))
        shippingDelivery.dateComponentsRange = PKDateComponentsRange(start: startComponents, end: endComponents)
        shippingDelivery.detail = "Items sent to your address"
        shippingDelivery.identifier = "DELIVERY"
        
        return [shippingDelivery]
    }
    
    func startPayment(products: [Product], total: Int, completion: @escaping PaymentCompletionHandler) {
        completionHandler = completion
        
        paymentSummaryItems = products.map { product in
            PKPaymentSummaryItem(label: product.name, amount: NSDecimalNumber(string: "\(product.price).00"), type: .final)
        }
        
        let totalItem = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(string: "\(total).00"), type: .final)
        paymentSummaryItems.append(totalItem)
        
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = paymentSummaryItems
        paymentRequest.merchantIdentifier = "merchant.com.pierrick.shopApp"
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = "CA"
        paymentRequest.currencyCode = "CAD"
        paymentRequest.supportedNetworks = PaymentHandler.supportedNetworks
        paymentRequest.shippingType = .delivery
        paymentRequest.shippingMethods = shippingMethodCalculator()
        paymentRequest.requiredShippingContactFields = [.name, .postalAddress]
        
        paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentController?.delegate = self
        
        paymentController?.present { presented in
            if presented {
                debugPrint("Presented payment controller")
            } else {
                debugPrint("Failed to present payment controller")
            }
        }
    }
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        let status = PKPaymentAuthorizationStatus.success
        completion(PKPaymentAuthorizationResult(status: status, errors: nil))
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            DispatchQueue.main.async {
                let success = self.paymentStatus == .success
                self.completionHandler?(success)
            }
        }
    }
}
