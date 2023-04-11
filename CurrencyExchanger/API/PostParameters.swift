//
//  PostParameters.swift
//  CurrencyExchanger
//
//  Created by Giorgi Katamadze on 4/10/23.
//

import Alamofire

enum PostParameters {

    case url([String: Any]?)
    case json([String: Any]?)
    case jsonArray([[String: Any]]?)

    var encoding: ParameterEncoding {
        switch self {
        case .url: return URLEncoding.default
        case .json: return JSONEncoding.default
        case .jsonArray: return ArrayEncoding()
        }
    }

    var parameters: Parameters? {
        switch self {
        case .json(let postParameters): return postParameters
        case .jsonArray(let postParametersArray): return postParametersArray?.asParameters()
        case .url(let postParameters):
            return postParameters
        }
    }
}
