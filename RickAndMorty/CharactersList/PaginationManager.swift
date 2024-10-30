//
//  PaginationManager.swift
//  RickAndMorty
//
//  Created by Leandro Berli on 30/10/2024.
//


final class PaginationManager {
    private(set) var currentPage = 1
    private(set) var totalPages: Int?
    
    var canLoadMore: Bool {
        guard let totalPages = totalPages else { return true }
        return currentPage < totalPages
    }
    
    func reset() {
        currentPage = 1
        totalPages = nil
    }
    
    func advancePage() {
        currentPage += 1
    }
    
    func setTotalPages(_ pages: Int) {
        totalPages = pages
    }
}