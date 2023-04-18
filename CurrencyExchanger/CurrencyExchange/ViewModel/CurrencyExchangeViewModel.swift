//
//  CurrencyExchangeViewModel.swift
//  CurrencyExchanger
//
//  Created by Giorgi Katamadze on 4/6/23.
//

import Foundation
import Combine
import UIKit

enum FieldType {
    case Buy
    case Sell
}
 
protocol CurrencyExchangeViewModelInput {
    func getExchangedMoney(type: FieldType)
}
protocol CurrencyExchangeViewModelOutput {
    func response(data:CurrencyExchangeEndPoint.Response?,error: Error?,type: FieldType)
}
protocol CurrencyExchangeViewModelType {
    var input:CurrencyExchangeViewModelInput { get }
    var output:CurrencyExchangeViewModelOutput? { get }
}

protocol CardDelegate {
    func configureCards(data:[MyWalletModel],type: CardViewType?)
}
final class CurrencyExchangeViewModel: CurrencyExchangeViewModelType {
    //MARK: - Properties
    var input: CurrencyExchangeViewModelInput { self }
    var output: CurrencyExchangeViewModelOutput?
    
    private var fromAmount: Double?
    private var fromCurrency: String?
    private var toCurrency: String?
    private var fromIndex = 0
    private var toIndex = 0
    var myWallet = [MyWalletModel]()
   
    
    //MARK: - Helpers
    private func getAccByIndex(currencySimbolFrom: String,currencySimbolTo: String) -> (fromAcc:MyWalletModel?,tooAcc:MyWalletModel?){
        if let indexFrom = myWallet.firstIndex(where: {$0.currencySymbol == currencySimbolFrom }),let indexTo =  myWallet.firstIndex(where: {$0.currencySymbol == currencySimbolTo }) {
            fromIndex = indexFrom
            toIndex = indexTo
            return (myWallet[indexFrom],myWallet[indexTo])
        }
        return (nil,nil)
    }
    
    func fillCurrencies(fromAmount: Double,currencySimbolFrom: String,currencySimbolTo: String) {
        self.fromAmount = fromAmount
        guard let fromAcc = getAccByIndex(currencySimbolFrom: currencySimbolFrom, currencySimbolTo: currencySimbolTo).fromAcc,
              let toAcc = getAccByIndex(currencySimbolFrom: currencySimbolFrom, currencySimbolTo: currencySimbolTo).tooAcc else { return }
        myWallet[fromIndex] = fromAcc
        myWallet[toIndex] = toAcc
        fromCurrency = fromAcc.currency
        toCurrency = toAcc.currency
    }
    private func fillMyWallet() {
        myWallet.removeAll()
        myWallet.append(MyWalletModel(amount: 1023, currency: "USD",currencySymbol:"$",cardAccNum: "GE******23"))
        myWallet.append(MyWalletModel(amount: 10, currency: "JPY",currencySymbol: "¥", cardAccNum: "GE******54"))
        myWallet.append(MyWalletModel(amount: 0, currency: "EUR",currencySymbol: "€", cardAccNum: "GE******09"))
        myWallet.append(MyWalletModel(amount: 100, currency: "GEL",currencySymbol: "₾", cardAccNum: "GE******08"))
    }
    func transfer(amount:Double,toAmount:Double,currencySimbolFrom:String,currencySimbolTo:String) -> [MyWalletModel] {
        guard var fromAcc = getAccByIndex(currencySimbolFrom: currencySimbolFrom, currencySimbolTo: currencySimbolTo).fromAcc,
              var toAcc = getAccByIndex(currencySimbolFrom: currencySimbolFrom, currencySimbolTo: currencySimbolTo).tooAcc else { return [] }
        guard fromAcc.balance ?? 0.0 >= amount else {
            return []
        }
        fromAcc.balance! -= amount
        toAcc.balance! += toAmount
        myWallet[fromIndex] = fromAcc
        myWallet[toIndex] = toAcc
        var result = [MyWalletModel]()
        result.removeAll()
        result.append(fromAcc)
        result.append(toAcc)
        
        return result
    }
    
    func whichCurrencyWeWantChoose()->[MyWalletModel] {
        fillMyWallet()
        let myWallet = myWallet.filter({$0.currency == "GEL" && $0.currency == "USD"})
        return myWallet == [] ? self.myWallet : myWallet
    }
}
//MARK: - CurrencyExchangeViewModelInput
extension  CurrencyExchangeViewModel: CurrencyExchangeViewModelInput {
    func getExchangedMoney(type: FieldType) {
        guard let fromAmount = fromAmount,let fromCurrency = fromCurrency , let toCurrency = toCurrency else { return }
        CurrencyExchangeEndPoint(fromAmount: fromAmount, fromCurrency: fromCurrency, toCurrency: toCurrency).fetch { [weak self] data,error in
            self?.output?.response(data:data,error:error, type: type)
        }
    }
}
