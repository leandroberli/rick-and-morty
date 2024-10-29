//
//  Info.swift
//  RickAndMorty
//
//  Created by Leandro Berli on 25/10/2024.
//
import SwiftUI

public struct Character: Codable, Hashable {
    let id: Int
    let name: String
    let image: String
    let status: CharcaterStatus //"Alive"
    let species: String //"Human"
    let gender: String
    let episode: [String]
    
    var episodeToString: String {
        let episodeNumbers = episode.map( { $0.replacingOccurrences(of: "https://rickandmortyapi.com/api/episode/", with: "")  })
        return episodeNumbers.joined(separator: ", ")
    }
    
    var idString: String {
        String(id)
    }
}

public enum CharcaterStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
    
    var textLabel: String {
        switch self {
        case .alive:
            return "● Alive"
        case .dead:
            return "● Dead"
        case .unknown:
            return "● unknown"
        }
    }
    
    var labelColor: Color {
        switch self {
        case .alive:
                return .green
        case .dead:
            return .red
        case .unknown:
            return .yellow
        }
    }
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

