//
//  SavedArticlesViewModel.swift
//  NewsApp
//
//  Created by Yin Hua on 12/7/2025.
//

import SwiftUI
import Combine

class SavedArticlesViewModel: ObservableObject {
    @Published var savedArticles: [SavedArticle] = []
    
    private let storageManager = StorageManager.shared
    
    init() {
        loadSavedArticles()
    }
    
    func loadSavedArticles() {
        savedArticles = storageManager.loadSavedArticles().sorted { $0.savedDate > $1.savedDate }
    }
    
    func removeArticle(_ article: SavedArticle) {
        storageManager.removeArticle(withId: article.id)
        loadSavedArticles()
    }
}
