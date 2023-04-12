//
//  Extensions + Array.swift
//  CurrencyExchanger
//
//  Created by Giorgi Katamadze on 4/12/23.
//

import Foundation
import Alamofire


extension Array {
    func asParameters() -> Parameters {
        return [ArrayEncoding.arrayParametersKey: self]
    }
}
