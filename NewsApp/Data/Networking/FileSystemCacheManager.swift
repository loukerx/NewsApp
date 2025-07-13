//
//  FileSystemCacheManager.swift
//  NewsApp
//
//  Created by Yin Hua on 13/7/2025.
//

import Foundation

// MARK: - Cache Models
struct CachedData<T: Codable>: Codable {
    let data: T
    let timestamp: Date
    let key: String
}

// MARK: - Cache Manager Protocol
protocol CacheManagerProtocol {
    func save<T: Codable>(_ data: T, for key: String) async throws
    func load<T: Codable>(_ type: T.Type, for key: String) async throws -> T?
    func isExpired(for key: String) async -> Bool
}

// MARK: - File System Cache Implementation
actor FileSystemCacheManager: CacheManagerProtocol {
    private let cacheDirectory: URL
    private let expirationInterval: TimeInterval
    
    init(expirationInterval: TimeInterval = 30 * 60) { // 30 mins
        self.expirationInterval = expirationInterval
        // get path
        let documentsPath = FileManager.default.urls(for: .cachesDirectory,
                                                    in: .userDomainMask).first!
        self.cacheDirectory = documentsPath.appendingPathComponent("NewsCache")
        
        // Create Directory
        try? FileManager.default.createDirectory(at: cacheDirectory,
                                               withIntermediateDirectories: true)
    }
    
    func save<T: Codable>(_ data: T, for key: String) async throws {
        let cachedData = CachedData(data: data, timestamp: Date(), key: key)
        let encoder = JSONEncoder()
        let encoded = try encoder.encode(cachedData)
        
        let fileURL = cacheDirectory.appendingPathComponent("\(key).json")
        try encoded.write(to: fileURL)
    }
    
    func load<T: Codable>(_ type: T.Type, for key: String) async throws -> T? {
        let fileURL = cacheDirectory.appendingPathComponent("\(key).json")
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        let cachedData = try decoder.decode(CachedData<T>.self, from: data)
        
        // check expired
        if Date().timeIntervalSince(cachedData.timestamp) > expirationInterval {
            try? FileManager.default.removeItem(at: fileURL)
            return nil
        }
        
        return cachedData.data
    }
    
    func isExpired(for key: String) async -> Bool {
        let fileURL = cacheDirectory.appendingPathComponent("\(key).json")
        
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: fileURL.path),
              let modificationDate = attributes[.modificationDate] as? Date else {
            return true
        }
        
        return Date().timeIntervalSince(modificationDate) > expirationInterval
    }
}
