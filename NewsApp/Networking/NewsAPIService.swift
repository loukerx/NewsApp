//
//  NewsAPIService.swift
//  NewsApp
//
//  Created by Yin Hua on 12/7/2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case networkError(String)
}

protocol NewsAPIServiceProtocol {
    func fetchSources() async throws -> [NewsSource]
    func fetchHeadlines(sources: [String]) async throws -> [Article]
}

class NewsAPIService: NewsAPIServiceProtocol {
    static let shared: NewsAPIServiceProtocol = NewsAPIService()
    
    private let apiKey = "5d25999f77db466193ddef3328f08978"
    private let baseURL = "https://newsapi.org/v2"
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchSources() async throws -> [NewsSource] {
        let urlString = "\(baseURL)/top-headlines/sources?language=en&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, _) = try await session.data(from: url)
            let response = try JSONDecoder().decode(SourcesResponse.self, from: data)
            return response.sources
        } catch {
            if error is DecodingError {
                throw NetworkError.decodingError
            } else {
                throw NetworkError.networkError(error.localizedDescription)
            }
        }
    }
    
    func fetchHeadlines(sources: [String]) async throws -> [Article] {
        guard !sources.isEmpty else { return [] }
        
        let sourcesString = sources.joined(separator: ",")
        let urlString = "\(baseURL)/top-headlines?sources=\(sourcesString)&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, _) = try await session.data(from: url)
            let response = try JSONDecoder().decode(ArticlesResponse.self, from: data)
            return response.articles
        } catch {
            if error is DecodingError {
                throw NetworkError.decodingError
            } else {
                throw NetworkError.networkError(error.localizedDescription)
            }
        }
    }
}
