//
//  NewsAppTests.swift
//  NewsAppTests
//
//  Created by Yin Hua on 12/7/2025.
//

import XCTest
@testable import NewsApp

class MockNewsAPIService: NewsAPIServiceProtocol {
    var shouldThrowError = false
    var mockSources: [NewsSource] = []
    var mockArticles: [Article] = []
    
    func fetchSources() async throws -> [NewsSource] {
        if shouldThrowError {
            throw NetworkError.networkError("Mock error")
        }
        return mockSources
    }
    
    func fetchHeadlines(sources: [String]) async throws -> [Article] {
        if shouldThrowError {
            throw NetworkError.networkError("Mock error")
        }
        return mockArticles
    }
}

// MARK: - Test Helpers for Models
extension NewsSource {
    /// Provides a simple initializer with default values for testing
    init(id: String, name: String) {
        self.init(
            id: id,
            name: name,
            description: "Test Description",
            url: "https://example.com",
            category: "general",
            language: "en",
            country: "us"
        )
    }
}


class MockCacheManager: CacheManagerProtocol {
 
    var expired = true
    var loadResult: Any?
    var savedKeys = [String]()

    func isExpired(for key: String) async -> Bool { expired }

    func load<T>(_ type: T.Type, for key: String) async throws -> T? {
        guard let result = loadResult as? T else { throw NSError() }
        return result
    }

    func save<T>(_ object: T, for key: String) async throws {
        savedKeys.append(key)
    }
}

// MARK: - Mock Article for Testing
extension Article {
    init(title: String, description: String?, url: String) {
        self.init(
            source: ArticleSource(id: "test id", name: "Test Source"),
            author: "Test Author",
            title: title,
            description: description,
            url: url,
            urlToImage: nil,
            publishedAt: Date().ISO8601Format(),
            content: nil
        )
    }
}
