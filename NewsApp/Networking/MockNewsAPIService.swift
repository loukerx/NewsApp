//
//  NewsAPIServiceTests.swift
//  NewsApp
//
//  Created by Yin Hua on 12/7/2025.
//

// Mock service for testing
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

