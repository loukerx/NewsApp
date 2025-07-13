//
//  SavedArticlesViewModelTests.swift
//  NewsApp
//
//  Created by Yin Hua on 13/7/2025.
//

import XCTest
@testable import NewsApp

class SavedArticlesViewModelTests: XCTestCase {
    
    // Clear all saved articles before each test
    override func setUp() {
        super.setUp()
        clearAllSavedArticles()
    }
    
    // Clear all saved articles after each test
    override func tearDown() {
        clearAllSavedArticles()
        super.tearDown()
    }
    
    private func clearAllSavedArticles() {
        let all = StorageManager.shared.loadSavedArticles()
        for article in all {
            StorageManager.shared.removeArticle(withId: article.id)
        }
    }
    
    /// When there are no saved articles, init() should produce an empty array
    func testInitWithNoSavedArticles() {
        let vm = SavedArticlesViewModel()
        XCTAssertTrue(vm.savedArticles.isEmpty, "Expected no saved articles initially")
    }
    
    /// If two articles are pre-saved, init() should load both of them
    func testInitLoadsSavedArticles() {
        let first = Article(title: "First", description: nil, url: "u1")
        let second = Article(title: "Second", description: "Desc", url: "u2")
        
        StorageManager.shared.saveArticle(first)
        StorageManager.shared.saveArticle(second)
        
        let vm = SavedArticlesViewModel()
        XCTAssertEqual(vm.savedArticles.count, 2, "Should load exactly two saved articles")
        
        let urls = vm.savedArticles.map { $0.url }
        XCTAssertTrue(urls.contains("u1"), "Expected to contain URL 'u1'")
        XCTAssertTrue(urls.contains("u2"), "Expected to contain URL 'u2'")
    }
    
    /// Calling removeArticle(_:) should delete that article and refresh the list
    func testRemoveArticleUpdatesList() {
        let article = Article(title: "ToRemove", description: nil, url: "u3")
        StorageManager.shared.saveArticle(article)
        
        let vm = SavedArticlesViewModel()
        XCTAssertEqual(vm.savedArticles.count, 1, "Expected one saved article before removal")
        
        let saved = vm.savedArticles[0]
        vm.removeArticle(saved)
        
        XCTAssertTrue(vm.savedArticles.isEmpty, "Expected no saved articles after removal")
    }
    
    /// loadSavedArticles() should fetch from storage and sort by savedDate descending
    func testLoadSavedArticlesReflectsStorageAndSorting() {
        let older = Article(title: "Old", description: nil, url: "u-old")
        let newer = Article(title: "New", description: nil, url: "u-new")
        
        StorageManager.shared.saveArticle(older)
        // Slight delay to ensure different savedDate timestamps
        Thread.sleep(forTimeInterval: 0.01)
        StorageManager.shared.saveArticle(newer)
        
        let vm = SavedArticlesViewModel()
        vm.loadSavedArticles()
        
        XCTAssertEqual(vm.savedArticles.count, 2, "Expected two articles after loading")
        XCTAssertEqual(vm.savedArticles[0].url, "u-new", "Newest article should come first")
        XCTAssertEqual(vm.savedArticles[1].url, "u-old", "Older article should come last")
    }
}
