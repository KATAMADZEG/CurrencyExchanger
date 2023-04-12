//
//  Extensions + String.swift
//  CurrencyExchanger
//
//  Created by Giorgi Katamadze on 4/12/23.
//

import Foundation



extension String {
    func makeQueryItems() -> [URLQueryItem]? {
        return split(separator: "&")
            .compactMap({ queryPart -> URLQueryItem? in
                let keyAndValue = queryPart.split(separator: "=")
                guard let key = keyAndValue.first else { return nil }
                let value = keyAndValue[1]
                
                return URLQueryItem(name: String(key), value: String(value))
            })
    }
    
    var queryParameters: [String: Any] {
        guard let queryItems = makeQueryItems(), queryItems.count > 0 else { return [:] }
        
        var parameters: [String: Any] = [:]
        
        queryItems.forEach { item in
            parameters[item.name] = item.value
        }
        
        return parameters
    }
}
