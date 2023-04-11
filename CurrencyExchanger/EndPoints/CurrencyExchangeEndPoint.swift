//
//  CurrencyExchangeEndPoint.swift
//  CurrencyExchanger
//
//  Created by Giorgi Katamadze on 4/10/23.
//

import Alamofire

struct CurrencyExchangeEndPoint: Endpoint {
    typealias Response = CurrencyExchangeModel
    
    
    var httpMethod: HTTPMethod = .get
    
    
    var fromAmount      : String
    var fromCurrency    : String
    var toCurrency      : String
    

    var path: String { "http://api.evp.lt/currency/commercial/exchange/\(fromAmount)-\(fromCurrency)/\(toCurrency)/latest" }
    
}
