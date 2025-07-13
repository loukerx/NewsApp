//
//  SavedArticleRowView.swift
//  NewsApp
//
//  Created by Yin Hua on 12/7/2025.
//

import Kingfisher
import SwiftUI

struct SavedArticleRowView: View {
    let savedArticle: SavedArticle
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Layout.smallPadding) {
            HStack(alignment: .top, spacing: AppConstants.Layout.defaultSpacing) {
                KFImage(savedArticle.unwappedImageURL)
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
                
                VStack(alignment: .leading, spacing: AppConstants.Layout.smallSpacing) {
                    Text(savedArticle.title)
                        .font(Theme.Typography.headline)
                        .lineLimit(nil)
                    
                    if let description = savedArticle.description {
                        Text(description)
                            .font(Theme.Typography.caption)
                            .lineLimit(nil)
                            .foregroundColor(Theme.Colors.secondary)
                    }
                    
                    HStack {
                        if let author = savedArticle.formattedAuthor {
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
