//
//  NewsRepositoryTests.swift
//  NewsApp
//
//  Created by Yin Hua on 13/7/2025.
//

import XCTest
@testable import NewsApp

class NewsRepositoryTests: XCTestCase {
    var mockAPI: MockNewsAPIService!
    var mockCache: MockCacheManager!
    var repository: NewsRepository!

    override func setUp() {
        super.setUp()
        mockAPI = MockNewsAPIService()
        mockCache = MockCacheManager()
        repository = NewsRepository(apiService: mockAPI, cacheManager: mockCache)
    }

    override func tearDown() {
        repository = nil
        mockCache = nil
        mockAPI = nil
        super.tearDown()
    }

    func testFetchSources_usesCacheWhenValid() async throws {
        let cached = [NewsSource(id: "x", name: "Cached")]
        mockCache.loadResult = cached
        mockCache.expired = false

        let sources = try await repository.fetchSources(forceFetch: false)
        XCTAssertEqual(sources, cached)
        XCTAssertFalse(mockAPI.shouldThrowError) // API not called
    }

    func testFetchSources_forceFetchIgnoresCache() async throws {
        mockCache.loadResult = [NewsSource(id: "x", name: "Old")]
        mockCache.expired = false
        mockAPI.mockSources = [NewsSource(id: "y", name: "New")]

        let sources = try await repository.fetchSources(forceFetch: true)
        XCTAssertEqual(sources.first?.id, "y")
        XCTAssertTrue(mockCache.savedKeys.contains("news_sources_en"))
    }

    func testFetchHeadlines_forceFetchIgnoresCache() async throws {
        mockCache.loadResult = [Article(title: "A", description: nil, url: "u")]
        mockCache.expired = false
        mockAPI.mockArticles = [Article(title: "B", description: nil, url: "uuu")]

        let articles = try await repository.fetchHeadlines(sources: ["s"], forceFetch: true)
        XCTAssertEqual(articles.first?.id, "uuu")
        XCTAssertTrue(mockCache.savedKeys.contains("headlines_s"))
    }
}
