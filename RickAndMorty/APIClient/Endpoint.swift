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

enum RickAndMortyEndpoint: APIEndpoint {
    case getAllCharacters
    
    var baseURL: URL {
        return URL(string: "https://rickandmortyapi.com")!
    }
    
    var path: String {
        "/api/character"
    }
    
    var method: HTTPMethod { .get }
    
    var headers: [String : String]? { nil }
    
    var parameters: [String : Any]? { nil }
}
