//
//  MyWalletModel.swift
//  CurrencyExchanger
//
//  Created by Giorgi Katamadze on 4/12/23.
//

import Foundation
import UIKit

struct MyWalletModel: Hashable {
    var id: UUID
    var balance: Double?
    var currency: String?
    var currencySymbol: String?
    var cardAccNum: String?
    
    
    init(amount: Double? = nil,currency: String? = nil,currencySymbol: String? = nil,cardAccNum:  String? = nil) {
        self.id = UUID()
        self.balance = amount
        self.currency = currency
        self.currencySymbol = currencySymbol
        self.cardAccNum = cardAccNum
    }
}
