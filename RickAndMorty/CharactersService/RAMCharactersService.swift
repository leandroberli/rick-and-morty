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
    func fetchCharacters(page: Int?, name: String?) -> AnyPublisher<GetAllCharactersResponse, Error>
}

public final class RAMCharactersService: RAMCharactersServiceProtocol {
    let apiClient = URLSessionAPIClient<RickAndMortyEndpoint>()
    
    public func fetchCharacters(page: Int?, name: String?) -> AnyPublisher<GetAllCharactersResponse, any Error> {
        return apiClient.request(.getAllCharacters(page: page, name: name))
    }
}
