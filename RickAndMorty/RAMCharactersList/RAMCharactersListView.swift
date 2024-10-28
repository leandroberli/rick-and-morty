//
//  RAMCHaractersListView.swift
//  RickAndMorty
//
//  Created by Leandro Berli on 25/10/2024.
//

import SwiftUI

struct RAMCHaractersListView: View {
    @StateObject var viewModel: RAMCharactersListViewModel = RAMCharactersListViewModel()
    @State var searchText: String = ""
    
    var columns: [GridItem] {
        [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
    }
    
    var itemWidth: CGFloat {
        UIScreen.main.bounds.width / 2 - 16
    }
    
    var itemHeight: CGFloat {
        (UIScreen.main.bounds.height - 44 - 20) / 3.5
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                if !viewModel.noSearchResults {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(viewModel.characters, id: \.self) { character in
                            NavigationLink(destination: {
                                RAMCharacterDetailView(character: character)
                            }, label: {
                                VStack(alignment: .leading, spacing: 8) {
                                    AsyncCachedImage(url: URL(string: character.image)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        Image(systemName: "photo")
                                            .imageScale(.large)
                                            .frame(width: 110, height: 110)
                                    }
                                    VStack(alignment: .leading, spacing: 0) {
                                        HStack {
                                            Text(character.name)
                                                .font(.system(size: 16, weight: .semibold))
                                                .lineLimit(1)
                                            Spacer()
                                            Text(character.status.rawValue)
                                                .font(.system(size: 12, weight: .regular))
                                                .foregroundStyle(character.status.labelColor)
                                        }
                                        Text(character.species)
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundStyle(Color(uiColor: .secondaryLabel))
                                    }
                                    .padding([.leading, .bottom, .trailing], 8)
                                }
                                .frame(width: itemWidth, height: itemHeight)
                                .onAppear {
                                    if character.id == viewModel.characters.last?.id {
                                        viewModel.setNextPageIfExists()
                                    }
                                }
                                .clipped()
                            })
                            .buttonStyle(.plain)
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .cornerRadius(8)
                        }
                    }
                    .padding([.leading, .bottom, .trailing])

                } else {
                    VStack {
                        Text("There is no results for the given name")
                            .font(.system(size: 14, weight: .regular))
                            .padding(.top, 32)
                    }
                }
                            }
            .navigationTitle("Characters")
            .searchable(text: $viewModel.searchString , prompt: Text("Type name"))
        }
        .onAppear {
            viewModel.setCharacters()
        }
        .accentColor(Color(uiColor: .label))
    }
}

@MainActor
struct AsyncCachedImage<ImageView: View, PlaceholderView: View>: View {
    // Input dependencies
    var url: URL?
    @ViewBuilder var content: (Image) -> ImageView
    @ViewBuilder var placeholder: () -> PlaceholderView
    
    // Downloaded image
    @State var image: UIImage? = nil
    
    init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> ImageView,
        @ViewBuilder placeholder: @escaping () -> PlaceholderView
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        VStack {
            if let uiImage = image {
                content(Image(uiImage: uiImage))
            } else {
                placeholder()
                    .onAppear {
                        Task {
                            image = await downloadPhoto()
                        }
                    }
            }
        }
    }
    
    // Downloads if the image is not cached already
    // Otherwise returns from the cache
    private func downloadPhoto() async -> UIImage? {
        do {
            guard let url else { return nil }
            
            // Check if the image is cached already
            if let cachedResponse = URLCache.shared.cachedResponse(for: .init(url: url)) {
                return UIImage(data: cachedResponse.data)
            } else {
                let (data, response) = try await URLSession.shared.data(from: url)
                
                // Save returned image data into the cache
                URLCache.shared.storeCachedResponse(.init(response: response, data: data), for: .init(url: url))
                
                guard let image = UIImage(data: data) else {
                    return nil
                }
                
                return image
            }
        } catch {
            print("Error downloading: \(error)")
            return nil
        }
    }
}
