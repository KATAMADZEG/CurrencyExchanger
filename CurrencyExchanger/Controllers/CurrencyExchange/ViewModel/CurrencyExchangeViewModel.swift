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
    func getExchangedMoney(type:FieldType)
}
protocol CurrencyExchangeViewModelOutput {
    func response(data:CurrencyExchangeEndPoint.Response?,error:Error?,type:FieldType)
}
protocol CurrencyExchangeViewModelType {
    var input:CurrencyExchangeViewModelInput{get}
    var output:CurrencyExchangeViewModelOutput?{get}
}


struct CurrencyExchangeViewModel:CurrencyExchangeViewModelType {
    var input: CurrencyExchangeViewModelInput{self}
    var output: CurrencyExchangeViewModelOutput?
    
    var fromAmount      :String?
    var fromCurrency    :String?
    var toCurrency      :String?
    
}
//MARK: - CurrencyExchangeViewModelInput
extension  CurrencyExchangeViewModel:CurrencyExchangeViewModelInput {
    func getExchangedMoney(type: FieldType) {
        CurrencyExchangeEndPoint(fromAmount: self.fromAmount ?? "", fromCurrency: self.fromCurrency ?? "", toCurrency: self.toCurrency ?? "").fetch { data, error in
            self.output?.response(data:data,error:error, type: type)
        }
    }
}
