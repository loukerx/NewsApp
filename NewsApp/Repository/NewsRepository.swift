//
//  NewsRepository.swift
//  NewsApp
//
//  Created by Yin Hua on 13/7/2025.
//

import Foundation

protocol NewsRepositoryProtocol {
    func fetchSources(forceFetch: Bool) async throws -> [NewsSource]
    func fetchHeadlines(sources: [String], forceFetch: Bool) async throws -> [Article]
}

class NewsRepository: NewsRepositoryProtocol {
    private let apiService: NewsAPIServiceProtocol
    private let cacheManager: CacheManagerProtocol
    
    init(apiService: NewsAPIServiceProtocol = NewsAPIService.shared,
         cacheManager: CacheManagerProtocol = FileSystemCacheManager()) {
        self.apiService = apiService
        self.cacheManager = cacheManager
    }
    
    private func validCached<T: Codable>(_ type: T.Type, key: String) async throws -> T? {
        let notExpired = !(await cacheManager.isExpired(for: key))
        guard notExpired else { return nil }
        return try await cacheManager.load(type, for: key)
    }

    func fetchSources(forceFetch: Bool) async throws -> [NewsSource] {
        let cacheKey = "news_sources_en"
        if !forceFetch, let cachedSources = try await validCached([NewsSource].self, key: cacheKey) {
            return cachedSources
        }
        let sources = try await apiService.fetchSources()
        try? await cacheManager.save(sources, for: cacheKey)
        return sources
    }
    
    func fetchHeadlines(sources: [String], forceFetch: Bool) async throws -> [Article] {
        let cacheKey = "headlines_\(sources.sorted().joined(separator: "_"))"
        if !forceFetch, let cachedArticles = try await validCached([Article].self, key: cacheKey) {
            return cachedArticles
        }
        let articles = try await apiService.fetchHeadlines(sources: sources)
        try? await cacheManager.save(articles, for: cacheKey)
        return articles
    }
}
