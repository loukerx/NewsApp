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
    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService: NewsAPIServiceProtocol
    private let storageManager = StorageManager.shared
    
    init(apiService: NewsAPIServiceProtocol = NewsAPIService.shared) {
        self.apiService = apiService
    }
    
    func loadHeadlines(for sources: Set<String>) async {
        guard !sources.isEmpty else {
            articles = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            articles = try await apiService.fetchHeadlines(sources: Array(sources))
        } catch {
            errorMessage = "Failed to load headlines: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func saveArticle(_ article: Article) {
        storageManager.saveArticle(article)
    }
    
    func isArticleSaved(_ article: Article) -> Bool {
        storageManager.isArticleSaved(article.id)
    }
}
