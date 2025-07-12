//
//  SavedArticleRowView.swift
//  NewsApp
//
//  Created by Yin Hua on 12/7/2025.
//

import SwiftUI

struct SavedArticleRowView: View {
    let savedArticle: SavedArticle
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Layout.smallPadding) {
            HStack(spacing: AppConstants.Layout.defaultSpacing) {
                AsyncImage(url: URL(string: savedArticle.urlToImage ?? "")) { image in
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
                
                VStack(alignment: .leading, spacing: AppConstants.Layout.smallSpacing) {
                    Text(savedArticle.title)
                        .font(Theme.Typography.headline)
                    
                    if let description = savedArticle.description {
                        Text(description)
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.secondary)
                    }
                    
                    HStack {
                        if let author = savedArticle.author {
                            Text(author)
                                .font(Theme.Typography.caption2)
                                .foregroundColor(Theme.Colors.secondary)
                        }
                        
                        Spacer()
                        
                        Text(savedArticle.savedDate, style: .date)
                            .font(Theme.Typography.caption2)
                            .foregroundColor(Theme.Colors.secondary)
                    }
                }
            }
        }
        .padding(.vertical, AppConstants.Layout.smallSpacing)
    }
}
