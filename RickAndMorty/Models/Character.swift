//
//  Info.swift
//  RickAndMorty
//
//  Created by Leandro Berli on 25/10/2024.
//

public struct Character: Codable, Hashable {
    let id: Int
    let name: String
    let image: String
    let status: String //"Alive"
    let species: String //"Human"
}

public struct GetAllCharactersResponse: Codable {
    let info: Info
    let results: [Character]
}

public struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

