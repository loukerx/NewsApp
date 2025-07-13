//
//  SourcesViewModelTests.swift
//  NewsApp
//
//  Created by Yin Hua on 13/7/2025.
//

import XCTest
@testable import NewsApp

@MainActor
class SourcesViewModelTests: XCTestCase {
    
    // A mock repository to simulate fetchSources behavior
    class MockRepo: NewsRepositoryProtocol {
        var sourcesToReturn: [NewsSource] = []
        var shouldThrow = false
        
        func fetchSources(forceFetch: Bool) async throws -> [NewsSource] {
            if shouldThrow {
                throw NetworkError.networkError("Mock Error")
            }
            return sourcesToReturn
        }
        
        func fetchHeadlines(sources: [String], forceFetch: Bool) async throws -> [Article] {
            return []
        }
    }
    
    var viewModel: SourcesViewModel!
    var mockRepo: MockRepo!
    
    // Clear persisted selectedSources before each test
    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: "selectedSources")
        mockRepo = MockRepo()
        viewModel = SourcesViewModel(repository: mockRepo)
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "selectedSources")
        viewModel = nil
        mockRepo = nil
        super.tearDown()
    }
    
    /// When storage has no saved source IDs, init() should start with an empty set
    func testInitWithNoSavedSelectedSources() {
        XCTAssertTrue(viewModel.selectedSources.isEmpty, "Expected no selected sources on init")
    }
    
    /// If storage already contains some IDs, init() should load them
    func testInitLoadsSavedSelectedSources() {
        // Pre-populate storage
        let saved: Set<String> = ["a", "b", "c"]
        StorageManager.shared.saveSelectedSources(saved)
        
        // Re-create the VM so init() picks up the saved set
        viewModel = SourcesViewModel(repository: mockRepo)
        
        XCTAssertEqual(viewModel.selectedSources, saved, "Expected init() to load saved selectedSources")
    }
    
    /// A successful fetch with non-empty array should set state to .loaded(...)
    func testLoadSourcesSuccess() async {
        let src1 = NewsSource(id: "1", name: "One")
        let src2 = NewsSource(id: "2", name: "Two")
        mockRepo.sourcesToReturn = [src1, src2]
        
        await viewModel.loadSources()
        
        if case .loaded(let sources) = viewModel.state {
            XCTAssertEqual(sources.count, 2)
            XCTAssertEqual(sources.map { $0.id }, ["1", "2"])
        } else {
            XCTFail("Expected .loaded, got \(viewModel.state)")
        }
    }
    
    /// A successful fetch returning an empty array should set state to .empty
    func testLoadSourcesEmpty() async {
        mockRepo.sourcesToReturn = []
        
        await viewModel.loadSources()
        
        if case .empty = viewModel.state {
            // pass
        } else {
            XCTFail("Expected .empty when repository returns no sources, got \(viewModel.state)")
        }
    }
    
    /// A throwing fetch should set state to .error(...) with the correct message
    func testLoadSourcesError() async {
        mockRepo.shouldThrow = true
        
        await viewModel.loadSources()
        
        if case .error(let msg) = viewModel.state {
            XCTAssertEqual(msg, AppConstants.Strings.networkErrorSources)
        } else {
            XCTFail("Expected .error, got \(viewModel.state)")
        }
    }
    
    /// toggleSource(_:) should add an ID when missing, remove it when present, and persist each change
    func testToggleSourcePersistsSelection() {
        // Initially empty
        XCTAssertTrue(viewModel.selectedSources.isEmpty)
        
        // Add "X"
        viewModel.toggleSource("X")
        XCTAssertTrue(viewModel.selectedSources.contains("X"))
        let fromStorageAfterAdd = StorageManager.shared.loadSelectedSources()
        XCTAssertTrue(fromStorageAfterAdd.contains("X"), "Expected storage to contain 'X' after toggling on")
        
        // Remove "X"
        viewModel.toggleSource("X")
        XCTAssertFalse(viewModel.selectedSources.contains("X"))
        let fromStorageAfterRemove = StorageManager.shared.loadSelectedSources()
        XCTAssertFalse(fromStorageAfterRemove.contains("X"), "Expected storage to not contain 'X' after toggling off")
    }
}
