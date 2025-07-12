//
//  SavedArticle.swift
//  NewsApp
//
//  Created by Yin Hua on 12/7/2025.
//

import Foundation

struct SavedArticle: Codable, Identifiable {
    let id: String
    let title: String
    let description: String?
    let author: String?
    let url: String
    let urlToImage: String?
    let savedDate: Date
    
    init(from article: Article) {
        self.id = article.id
        self.title = article.title
        self.description = article.description
        self.author = article.author
        self.url = article.url
        self.urlToImage = article.urlToImage
        self.savedDate = Date()
    }
}
