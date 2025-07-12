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
        HStack(spacing: AppConstants.Layout.defaultSpacing) {
            // Thumbnail
            AsyncImage(url: URL(string: article.urlToImage ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: AppConstants.Layout.thumbnailSize, height: AppConstants.Layout.thumbnailSize)
                    .clipped()
                    .cornerRadius(AppConstants.Layout.cornerRadius)
            } placeholder: {
                RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadius)
                    .fill(Theme.Colors.placeholder)
                    .frame(width: AppConstants.Layout.thumbnailSize, height: AppConstants.Layout.thumbnailSize)
            }
            
            // Content
            VStack(alignment: .leading, spacing: AppConstants.Layout.smallSpacing) {
                Text(article.title)
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.primary)
                
                if let description = article.description {
                    Text(description)
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.secondary)
                }
                
                HStack {
                    if let author = article.author {
                        Text(author)
                            .font(Theme.Typography.caption2)
                            .foregroundColor(Theme.Colors.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: onSave) {
                        Image(systemName: isSaved ? AppConstants.Images.bookmarkFill : AppConstants.Images.bookmark)
                            .foregroundColor(isSaved ? Theme.Colors.accent : .gray)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, AppConstants.Layout.smallPadding)
    }
}
