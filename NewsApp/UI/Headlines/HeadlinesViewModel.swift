//
//  HeadlinesViewModel.swift
//  NewsApp
//
//  Created by Yin Hua on 12/7/2025.
//

import SwiftUI
import Combine

@MainActor
class HeadlinesViewModel: ObservableObject {
    enum HeadlinesState {
        case loading
        case loaded([Article])
        case empty
        case error(String)
    }

    @Published var state: HeadlinesState = .loading
    var selectedSources: Set<String> = []

    private let apiService: NewsAPIServiceProtocol
    private let storageManager = StorageManager.shared
    
    init(apiService: NewsAPIServiceProtocol = NewsAPIService.shared) {
        self.apiService = apiService
        loadSelectedSources()
    }
    
    private func loadSelectedSources() {
        selectedSources = storageManager.loadSelectedSources()
    }

    func reloadHeadlines() async {
        loadSelectedSources()
        await loadHeadlines(for: selectedSources)
    }
    
    func loadHeadlines(for sources: Set<String>) async {
        guard !sources.isEmpty else {
            state = .empty
            return
        }
        
        state = .loading
        
        do {
            let articles = try await apiService.fetchHeadlines(sources: Array(sources))
            if articles.isEmpty {
                state = .empty
            } else {
                state = .loaded(articles)
            }
        } catch {
            state = .error("Failed to load headlines: \(error.localizedDescription)")
        }
    }

    func saveArticle(_ article: Article) {
        storageManager.saveArticle(article)
    }
    
    func isArticleSaved(_ article: Article) -> Bool {
        storageManager.isArticleSaved(article.id)
    }
}
