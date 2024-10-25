//
//  CitiesService.swift
//  UalaChallenge
//
//  Created by Leandro Berli on 16/10/2024.
//

import Foundation
import Combine

//MARK: Service
public protocol RAMCharactersServiceProtocol {
    func fetchCharacters() -> AnyPublisher<GetAllCharactersResponse, Error>
}

public final class RAMCharactersService: RAMCharactersServiceProtocol {
    let apiClient = URLSessionAPIClient<RickAndMortyEndpoint>()
    
    public func fetchCharacters() -> AnyPublisher<GetAllCharactersResponse, any Error> {
        return apiClient.request(.getAllCharacters)
    }
}
