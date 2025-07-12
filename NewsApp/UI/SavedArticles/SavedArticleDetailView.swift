//
//  SavedArticleDetailView.swift
//  NewsApp
//
//  Created by Yin Hua on 12/7/2025.
//

import SwiftUI

struct SavedArticleDetailView: View {
    let savedArticle: SavedArticle
    
    var body: some View {
        if let url = URL(string: savedArticle.url) {
            WebView(url: url)
                .navigationBarTitleDisplayMode(.inline)
        } else {
            Text(AppConstants.Strings.invalidURL)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

