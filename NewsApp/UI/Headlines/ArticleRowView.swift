//
//  ArticleRowView.swift
//  NewsApp
//
//  Created by Yin Hua on 12/7/2025.
//

import Kingfisher
import SwiftUI

struct ArticleRowView: View {
    let article: Article
    let isSaved: Bool
    let onSave: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: AppConstants.Layout.defaultSpacing) {
            KFImage(article.unwappedImageURL)
                .placeholder {
                    RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadius)
                        .fill(Theme.Colors.placeholder)
                        .frame(width: AppConstants.Layout.thumbnailSize, height: AppConstants.Layout.thumbnailSize)
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: AppConstants.Layout.thumbnailSize, height: AppConstants.Layout.thumbnailSize)
                .clipped()
                .cornerRadius(AppConstants.Layout.cornerRadius)
            
            // Content
            VStack(alignment: .leading, spacing: AppConstants.Layout.smallSpacing) {
                Text(article.title)
                    .font(Theme.Typography.headline)
                    .lineLimit(2)
                    .foregroundColor(Theme.Colors.primary)
                
                if let description = article.description {
                    Text(description)
                        .font(Theme.Typography.caption)
                        .lineLimit(2)
                        .foregroundColor(Theme.Colors.secondary)
                }
                
                HStack {
                    if let author = article.formattedAuthor {
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
        .padding(.vertical, AppConstants.Layout.smallSpacing)
    }
}
