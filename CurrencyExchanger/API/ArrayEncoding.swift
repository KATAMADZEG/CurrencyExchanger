//
//  ArrayEncoding.swift
//  CurrencyExchanger
//
//  Created by Giorgi Katamadze on 4/10/23.
//

import Alamofire

struct ArrayEncoding: ParameterEncoding {

    static let arrayParametersKey = "htParamArrayParametersKey"

    let options: JSONSerialization.WritingOptions

    init(options: JSONSerialization.WritingOptions = []) {
        self.options = options
    }

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()

        guard
            let parameters = parameters,
            let array = parameters[ArrayEncoding.arrayParametersKey]
        else {
            return urlRequest
        }

        do {
            let data = try JSONSerialization.data(withJSONObject: array, options: options)

            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }

            urlRequest.httpBody = data
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }

        return urlRequest
    }
}
