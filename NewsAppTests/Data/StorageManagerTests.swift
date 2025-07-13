//
//  StorageManagerTests.swift
//  NewsApp
//
//  Created by Yin Hua on 13/7/2025.
//
import XCTest
@testable import NewsApp

class StorageManagerTests: XCTestCase {
    private let defaults = UserDefaults.standard
    private let selectedKey = "selectedSources"
    private let articlesKey = "savedArticles"

    override func setUp() {
        super.setUp()
        // Clean out UserDefaults before each test
        defaults.removeObject(forKey: selectedKey)
        defaults.removeObject(forKey: articlesKey)
    }

    // MARK: - Selected Sources
    func testSaveAndLoadSelectedSources() {
        let sources: Set<String> = ["source1", "source2"]
        StorageManager.shared.saveSelectedSources(sources)
        let loaded = StorageManager.shared.loadSelectedSources()
        XCTAssertEqual(loaded, sources)
    }

    func testLoadSelectedSourcesDefaultEmpty() {
        let loaded = StorageManager.shared.loadSelectedSources()
        XCTAssertTrue(loaded.isEmpty)
    }

    // MARK: - Saved Articles
    func testSaveArticleAndLoadSavedArticles() {
        // Using the extension initializer: init(id:title:description:url:)
        let article = Article(title: "Test", description: "Body", url: "https://example.com")
        StorageManager.shared.saveArticle(article)

        let saved = StorageManager.shared.loadSavedArticles()
        XCTAssertEqual(saved.count, 1)
        XCTAssertTrue(StorageManager.shared.isArticleSaved(article.id))
    }

    func testAvoidDuplicateArticles() {
        let article = Article(title: "Dup", description: "Body", url: "https://example.com")
        StorageManager.shared.saveArticle(article)
        StorageManager.shared.saveArticle(article)

        let saved = StorageManager.shared.loadSavedArticles()
        // Should still be only one entry
        XCTAssertEqual(saved.count, 1)
    }

    func testRemoveArticle() {
        let article = Article(title: "Temp", description: "Body", url: "https://example.com")
        StorageManager.shared.saveArticle(article)
        XCTAssertTrue(StorageManager.shared.isArticleSaved(article.id))

        StorageManager.shared.removeArticle(withId: article.id)
        let saved = StorageManager.shared.loadSavedArticles()
        XCTAssertTrue(saved.isEmpty)
        XCTAssertFalse(StorageManager.shared.isArticleSaved(article.id))
    }
}

