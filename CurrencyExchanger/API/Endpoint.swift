//
//  Endpoint.swift
//  CurrencyExchanger
//
//  Created by Giorgi Katamadze on 4/10/23.
//

import Alamofire
import Foundation
import Combine

// MARK: - Protocol Definition

protocol Endpoint {
    
    associatedtype Response: Decodable
    
    func url(_ baseURL: URL) -> URL?
    
    var postParameters: PostParameters { get }
        
    var useSslPinning: Bool { get }
        
    var queryItems: [URLQueryItem]? { get }
    
    var headerItems: HTTPHeaders? { get }
    
    var query: String? { get }
    
    var path: String { get }
    
    var httpMethod: HTTPMethod { get }
    
    var customBaseUrl: URL? { get }
    
    func future() -> AnyPublisher<Response, Error>
}

// MARK: - Default Implementation

extension Endpoint {
    
    var query: String? { nil }

    var httpMethod: HTTPMethod { .get }
        
    func url(_ baseURL: URL) -> URL? {
        var components = URLComponents()

        components.path = path
        components.queryItems = queryItems
        
        return components.url(relativeTo: baseURL)
    }
    
    var postParameters: PostParameters { .url(nil) }
    
    var useSslPinning: Bool { false }
        
    var queryItems: [URLQueryItem]? {
        return query?.makeQueryItems()
    }
    
    var headerItems: HTTPHeaders? { nil }
        
    var customBaseUrl: URL? { nil }
}


// MARK: - Default Values

extension Endpoint {
    
    private var defaultHeaders: HTTPHeaders { [] }
    
    private var session: Alamofire.Session {
        AF
    }
}

extension JSONDecoder {
    
    static var convertFromSnakeCaseDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}

enum EndpointError: Error {
    case noUrl
    case noResponse
}


// MARK: - Making calls

extension Endpoint {
    
    func future() -> AnyPublisher<Response, Error> {
        Future { promise in
            fetch { response, error in
                if let response = response {
                    promise(.success(response))
                } else if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.failure(EndpointError.noResponse))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    @discardableResult
    func fetch(completeOnMain: Bool = true, completion: @escaping (Response?, Error?) -> Void) -> Request? {

//        guard let url = customBaseUrl else {
//            completion(nil, EndpointError.noUrl)
//            return nil
//        }
        
        var headers = defaultHeaders
        
        if let customHeaders = headerItems {
            customHeaders.forEach { headers.add($0) }
        }
        
        let queue = DispatchQueue(label: "DispatchQueue.Request", attributes: [.concurrent])
        
        return session.request (
            path,
            method: httpMethod,
            parameters: postParameters.parameters,
            encoding: postParameters.encoding,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .responseDecodable(
            of: Response.self,
            queue: queue,
            decoder: JSONDecoder.convertFromSnakeCaseDecoder,
            emptyResponseCodes: [200, 201, 202, 203, 204, 205]
        ) { response in
            
            switch response.result {
                
            case .success(let decodedResponse):
                
                guard completeOnMain else {
                    completion(decodedResponse, nil)
                    return
                }
                
                DispatchQueue.main.async {
                    completion(decodedResponse, nil)
                }
                
            case .failure(let error):
                
                guard completeOnMain else {
                    completion(nil, error)
                    return
                }
                
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
}
