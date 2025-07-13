//
//  StorageManager.swift
//  NewsApp
//
//  Created by Yin Hua on 12/7/2025.
//

import Foundation

class StorageManager {
    static let shared = StorageManager()
    private let selectedSourcesKey = "selectedSources"
    private let savedArticlesKey = "savedArticles"
    
    private init() {}
    
    // MARK: Selected Sources
    func saveSelectedSources(_ sources: Set<String>) {
        let array = Array(sources)
        UserDefaults.standard.set(array, forKey: selectedSourcesKey)
    }
    
    func loadSelectedSources() -> Set<String> {
        let array = UserDefaults.standard.stringArray(forKey: selectedSourcesKey) ?? []
        return Set(array)
    }
    
    // MARK: Saved Articles
    func saveArticle(_ article: Article) {
        var savedArticles = loadSavedArticles()
        let savedArticle = SavedArticle(from: article)
        
        // Avoid duplicates
        if !savedArticles.contains(where: { $0.id == savedArticle.id }) {
            savedArticles.append(savedArticle)
            saveSavedArticles(savedArticles)
        }
    }

    func removeArticle(withId id: String) {
        var savedArticles = loadSavedArticles()
        savedArticles.removeAll { $0.id == id }
        saveSavedArticles(savedArticles)
    }
    
    func loadSavedArticles() -> [SavedArticle] {
        guard let data = UserDefaults.standard.data(forKey: savedArticlesKey),
              let articles = try? JSONDecoder().decode([SavedArticle].self, from: data) else {
            return []
        }
        return articles
    }
    
    func isArticleSaved(_ articleId: String) -> Bool {
        let savedArticles = loadSavedArticles()
        return savedArticles.contains { $0.id == articleId }
    }

    private func saveSavedArticles(_ articles: [SavedArticle]) {
        if let data = try? JSONEncoder().encode(articles) {
            UserDefaults.standard.set(data, forKey: savedArticlesKey)
        }
    }
}

