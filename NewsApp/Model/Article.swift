//
//  Article.swift
//  NewsApp
//
//  Created by Yin Hua on 12/7/2025.
//

import Foundation

struct Article: Codable, Identifiable {
    let source: ArticleSource
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    
    var id: String { url }
}

struct ArticleSource: Codable {
    let id: String?
    let name: String
}

struct ArticlesResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
