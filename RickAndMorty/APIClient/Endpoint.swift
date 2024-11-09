//
//  Endpoint.swift
//  UalaChallenge
//
//  Created by Leandro Berli on 16/10/2024.
//

import Foundation

protocol APIEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum APIError: Error {
    case invalidResponse
    case invalidData
}

enum RickAndMortyURLConfiguration {
    case production
    case uiTestsLocalhost
    
    var host: String {
        switch self {
        case .production:
            "rickandmortyapi.com"
        case .uiTestsLocalhost:
            "localhost"
        }
    }
}

enum RickAndMortyEndpoint: APIEndpoint {
    case getAllCharacters(page: Int?, name: String?)
    
    var baseURL: URL {
        let isMockServerUITesting = ProcessInfo.processInfo.arguments.contains("-mockServer")
        var components = URLComponents()
        if isMockServerUITesting {
            components.scheme = "http"
            components.host = RickAndMortyURLConfiguration.uiTestsLocalhost.host
            components.port = 8888
        } else {
            components.scheme = "https"
            components.host = RickAndMortyURLConfiguration.production.host
        }
        components.path = path
        if let params = parameters {
            components.queryItems = params.map( { URLQueryItem(name: $0.key, value: "\($0.value)" ) } )
        }
        
        return components.url!
    }
    
    var path: String {
        "/api/character"
    }
    
    var method: HTTPMethod { .get }
    
    var headers: [String : String]? { nil }
    
    var parameters: [String : Any]? {
        switch self {
        case .getAllCharacters(let page, let name):
            var parameters: [String: Any] = [:]
            if let page = page {
                parameters["page"] = page
            }
            if let name = name {
                parameters["name"] = name
            }
            return parameters
        }
    }
}
