//
//  ArticleDetailView.swift
//  NewsApp
//
//  Created by Yin Hua on 12/7/2025.
//

import SwiftUI

struct ArticleDetailView: View {
    let article: Article
    
    var body: some View {
        if let url = URL(string: article.url) {
            WebView(url: url)
                .navigationTitle(article.source.name)
                .navigationBarTitleDisplayMode(.inline)
        } else {
            Text("Invalid URL")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

