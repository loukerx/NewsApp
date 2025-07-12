//
//  Sources.swift
//  NewsApp
//
//  Created by Yin Hua on 12/7/2025.
//

import Foundation

// Source Model
struct NewsSource: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
    let url: String
    let category: String
    let language: String
    let country: String
}

struct SourcesResponse: Codable {
    let status: String
    let sources: [NewsSource]
}
