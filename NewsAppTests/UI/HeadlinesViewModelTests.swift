//
//  HeadlinesViewModelTests.swift
//  NewsApp
//
//  Created by Yin Hua on 13/7/2025.
//
import XCTest
@testable import NewsApp

@MainActor
class HeadlinesViewModelTests: XCTestCase {
    
    // MARK: - Mock Repository
    class MockRepo: NewsRepositoryProtocol {
        var headlinesToReturn: [Article] = []
        var shouldThrow = false
        
        func fetchSources(forceFetch: Bool) async throws -> [NewsSource] { [] }
        
        func fetchHeadlines(sources: [String], forceFetch: Bool) async throws -> [Article] {
            if shouldThrow {
                throw NetworkError.networkError("VM Mock Error")
            }
            return headlinesToReturn
        }
    }
    
    var viewModel: HeadlinesViewModel!
    var mockRepo: MockRepo!

    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: "savedArticles")
        
        mockRepo = MockRepo()
        viewModel = HeadlinesViewModel(repository: mockRepo)
    }

    override func tearDown() {
        viewModel = nil
        mockRepo = nil
        super.tearDown()
    }

    func testLoadHeadlinesEmptySources() async {
        await viewModel.loadHeadlines(for: [], forceFetch: false)
        if case .empty = viewModel.state {
            // pass
        } else {
            XCTFail("Expected .empty, got \(viewModel.state)")
        }
    }

    func testLoadHeadlinesSuccess() async {
        let article = Article(title: "Test Title", description: "Desc", url: "https://u")
        mockRepo.headlinesToReturn = [article]

        await viewModel.loadHeadlines(for: ["sourceA"], forceFetch: false)

        if case .loaded(let articles) = viewModel.state {
            XCTAssertEqual(articles.count, 1)
            XCTAssertEqual(articles.first?.title, article.title)
            XCTAssertEqual(articles.first?.description, article.description)
            XCTAssertEqual(articles.first?.url, article.url)
        } else {
            XCTFail("Expected .loaded, got \(viewModel.state)")
        }
    }

    func testLoadHeadlinesNoArticles() async {
        mockRepo.headlinesToReturn = []
        await viewModel.loadHeadlines(for: ["sourceA"], forceFetch: false)

        if case .empty = viewModel.state {
            // pass
        } else {
            XCTFail("Expected .empty when no articles, got \(viewModel.state)")
        }
    }

    func testLoadHeadlinesError() async {
        mockRepo.shouldThrow = true
        await viewModel.loadHeadlines(for: ["sourceA"], forceFetch: false)

        if case .error(let msg) = viewModel.state {
            XCTAssertEqual(msg, AppConstants.Strings.networkErrorHeadlines)
        } else {
            XCTFail("Expected .error, got \(viewModel.state)")
        }
    }

    func testToggleSaveArticle_andIsArticleSaved() {
        let article = Article(title: "Saved", description: nil, url: "u")
  
        XCTAssertFalse(viewModel.isArticleSaved(article))
        
        viewModel.toggleSaveArticle(article)
        XCTAssertTrue(viewModel.isArticleSaved(article))

        viewModel.toggleSaveArticle(article)
        XCTAssertFalse(viewModel.isArticleSaved(article))
    }
}
