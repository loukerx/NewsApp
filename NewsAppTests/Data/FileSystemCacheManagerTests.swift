//
//  FileSystemCacheManagerTests.swift
//  NewsApp
//
//  Created by Yin Hua on 13/7/2025.
//

import XCTest
@testable import NewsApp

// MARK: - Test Models
struct TestModel: Codable, Equatable {
    let id: Int
    let name: String
    let timestamp: Date
}

// MARK: - Cache Manager Tests
final class FileSystemCacheManagerTests: XCTestCase {
    
    private var cacheManager: FileSystemCacheManager!
    private let testKey = "test_key"
    private let testModel = TestModel(id: 1, name: "Test", timestamp: Date())
    
    override func setUp() async throws {
        try await super.setUp()
        cacheManager = FileSystemCacheManager(expirationInterval: 2.0)
    }
    
    override func tearDown() async throws {
        await clearTestCache()
        try await super.tearDown()
    }

    func testSaveData() async throws {
        let testData = testModel

        try await cacheManager.save(testData, for: testKey)

        let loaded = try await cacheManager.load(TestModel.self, for: testKey)
        XCTAssertNotNil(loaded)
        XCTAssertEqual(loaded, testData)
    }

    func testLoadNonExistentData() async throws {
        let loaded = try await cacheManager.load(TestModel.self, for: "non_existent_key")

        XCTAssertNil(loaded)
    }
    
    func testLoadExpiredData() async throws {
        try await cacheManager.save(testModel, for: testKey)

        try await Task.sleep(nanoseconds: 3_000_000_000)

        let loaded = try await cacheManager.load(TestModel.self, for: testKey)
        XCTAssertNil(loaded, "3 seconds data should be expired")
    }
    
    func testLoadValidData() async throws {
        try await cacheManager.save(testModel, for: testKey)
        let loaded = try await cacheManager.load(TestModel.self, for: testKey)
        XCTAssertNotNil(loaded)
        XCTAssertEqual(loaded, testModel)
    }
    
    func testIsExpiredForValidCache() async throws {
        try await cacheManager.save(testModel, for: testKey)
        let isExpired = await cacheManager.isExpired(for: testKey)
        XCTAssertFalse(isExpired, "If just saved cache should not return true")
    }
    
    func testIsExpiredForExpiredCache() async throws {
        try await cacheManager.save(testModel, for: testKey)
        try await Task.sleep(nanoseconds: 3_000_000_000)
        let isExpired = await cacheManager.isExpired(for: testKey)
        XCTAssertTrue(isExpired, "expried cache should return true")
    }
  
    private func clearTestCache() async {
        let documentsPath = FileManager.default.urls(for: .cachesDirectory,
                                                    in: .userDomainMask).first!
        let cacheDirectory = documentsPath.appendingPathComponent("NewsCache")
        
        if let files = try? FileManager.default.contentsOfDirectory(at: cacheDirectory,
                                                                   includingPropertiesForKeys: nil) {
            for file in files {
                try? FileManager.default.removeItem(at: file)
            }
        }
    }
}
