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
    // This variable need to be updated when user save/delete articles in Saved Tab
    @Published var savedArticleIDs: Set<String> = []
    var selectedSources: Set<String> = []

    private let storageManager = StorageManager.shared
    private let repository: NewsRepositoryProtocol
    
    init(repository: NewsRepositoryProtocol = NewsRepository()) {
        self.repository = repository
    }
    
    private func loadSelectedSources() {
        selectedSources = storageManager.loadSelectedSources()
    }
    func reloadHeadlines(forceFetch: Bool = false) async {
        loadSelectedSources()
        loadSavedArticleIds()
        await loadHeadlines(for: selectedSources, forceFetch: forceFetch)
    }

    func loadHeadlines(for sources: Set<String>, forceFetch: Bool) async {
        guard !sources.isEmpty else {
            state = .empty
            return
        }
        
        state = .loading
        
        do {
            let articles = try await repository.fetchHeadlines(sources: Array(sources), forceFetch: forceFetch)
            if articles.isEmpty {
                state = .empty
            } else {
                state = .loaded(articles)
            }
        } catch {
            state = .error(AppConstants.Strings.networkErrorHeadlines)
        }
    }

    func toggleSaveArticle(_ article: Article) {
        if savedArticleIDs.contains(article.id) {
            storageManager.removeArticle(withId: article.id)
            savedArticleIDs.remove(article.id)
        } else {
            storageManager.saveArticle(article)
            savedArticleIDs.insert(article.id)
        }
    }

    func isArticleSaved(_ article: Article) -> Bool {
        savedArticleIDs.contains(article.id)
    }
    
    func loadSavedArticleIds() {
        let savedArticles = storageManager.loadSavedArticles()
        savedArticleIDs = Set(savedArticles.map { $0.id })
    }

}
