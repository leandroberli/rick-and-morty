//
//  RAMCharactersViewModel.swift
//  RickAndMorty
//
//  Created by Leandro Berli on 25/10/2024.
//
import Foundation
import Combine

final class RAMCharactersListViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published public var characters: [Character] = []
    @Published public var searchString: String = ""
    @Published var noSearchResults: Bool = false
    private var prevSearchString: String = ""
    private var charactersService: RAMCharactersServiceProtocol
    private var response: GetAllCharactersResponse?
    var currentPage = 1
    
    init(charactersService: RAMCharactersServiceProtocol = RAMCharactersService()) {
        self.charactersService = charactersService
        bindSearchText()
    }
    
    private func bindSearchText() {
        $searchString
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] searchString in
                guard let self = self else {
                    return
                }
                self.searchCharacters()
            })
            .store(in: &cancellables)
    }
    
    public func setCharacters() {
        fetchCharacters(handleResponseBlock: { [weak self] response in
            guard let self = self else {
                return
            }
            self.response = response
            self.characters = response.results
        })
    }
    
    public func setNextPageIfExists() {
        guard let response = response, currentPage < response.info.pages else {
            return
        }
        currentPage += 1
        fetchCharacters(handleResponseBlock: { [weak self] newPageResponse in
            guard let self = self else { return }
            self.response = newPageResponse
            self.characters.append(contentsOf: newPageResponse.results)
        })
    }
    
    public func searchCharacters() {
        if searchString != prevSearchString {
            resetToNewSearch()
            fetchCharacters(handleResponseBlock: { [weak self] response in
                guard let self = self else { return }
                self.prevSearchString = self.searchString
                self.response = response
                self.characters = response.results
            })
        }
    }
    
    private func resetToNewSearch() {
        self.prevSearchString = searchString
        self.currentPage = 1
        self.response = nil
    }
    
    private func fetchCharacters(handleResponseBlock: @escaping (GetAllCharactersResponse) -> Void) {
        charactersService.fetchCharacters(page: currentPage, name: searchString)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .finished:
                    break
                case .failure(let failure):
                    self.noSearchResults = true
                    print(failure.localizedDescription)
                }
            }, receiveValue: { [weak self] newPageResponse in
                guard let self = self else { return }
                handleResponseBlock(newPageResponse)
                self.noSearchResults = false
            })
            .store(in: &cancellables)
    }
}

