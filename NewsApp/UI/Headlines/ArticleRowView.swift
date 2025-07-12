//
//  ArticleRowView.swift
//  NewsApp
//
//  Created by Yin Hua on 12/7/2025.
//

import SwiftUI

struct ArticleRowView: View {
    let article: Article
    let isSaved: Bool
    let onSave: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Thumbnail
            AsyncImage(url: URL(string: article.urlToImage ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipped()
                    .cornerRadius(8)
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 80)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                
                if let description = article.description {
                    Text(description)
                        .font(.caption)
                        .lineLimit(2)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    if let author = article.author {
                        Text(author)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: onSave) {
                        Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                            .foregroundColor(isSaved ? .blue : .gray)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 8)
    }
}
