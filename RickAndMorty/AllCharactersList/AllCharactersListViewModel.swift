//
//  RAMCharactersViewModel.swift
//  RickAndMorty
//
//  Created by Leandro Berli on 25/10/2024.
//
import Foundation
import Combine

final class AllCharactersListViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published public var characters: [FavoritableCharacter] = []
    @Published public var searchString: String = ""
    @Published var noSearchResults: Bool = false
    private var prevSearchString: String = ""
    private var charactersService: RAMCharactersServiceProtocol
    public var paginationManager: PaginationManager = PaginationManager()
    
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
    
    public func setCharactersFirstPage() {
        self.paginationManager.reset()
        fetchCharacters(handleResponseBlock: { [weak self] response in
            guard let self = self else {
                return
            }
            self.paginationManager.setTotalPages(response.info.pages)
            self.characters = response.results.map({ FavoritableCharacter(data: $0) })
        })
    }
    
    public func setNextCharactersPageIfExists() {
        guard paginationManager.canLoadMore else {
            return
        }
        paginationManager.advancePage()
        fetchCharacters(handleResponseBlock: { [weak self] newPageResponse in
            guard let self = self else { return }
            self.characters.append(contentsOf: newPageResponse.results.map({ FavoritableCharacter(data: $0) }))
        })
    }
    
    public func searchCharacters() {
        if searchString != prevSearchString {
            resetToNewSearch()
            fetchCharacters(handleResponseBlock: { [weak self] response in
                guard let self = self else { return }
                self.prevSearchString = self.searchString
                self.paginationManager.setTotalPages(response.info.pages)
                self.characters = response.results.map({ FavoritableCharacter(data: $0) })
            })
        }
    }
    
    public func toggleFavorite(character: Character) {
        if let index = characters.firstIndex(where: { $0.data.id == character.id }) {
            characters[index].isFavorite = !characters[index].isFavorite
        }
    }
    
    private func resetToNewSearch() {
        prevSearchString = searchString
        paginationManager.reset()
    }
    
    private func fetchCharacters(handleResponseBlock: @escaping (GetAllCharactersResponse) -> Void) {
        charactersService.fetchCharacters(page: paginationManager.currentPage, name: searchString)
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



