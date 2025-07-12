//
//  AppConstants.swift
//  NewsApp
//
//  Created by Yin Hua on 12/7/2025.
//

import Foundation

enum AppConstants {
    enum Layout {
        static let defaultPadding: CGFloat = 16
        static let smallPadding: CGFloat = 8
        static let largePadding: CGFloat = 20
        static let defaultSpacing: CGFloat = 12
        static let smallSpacing: CGFloat = 4
        static let largeSpacing: CGFloat = 20
        
        static let thumbnailSize: CGFloat = 80
        static let cornerRadius: CGFloat = 8
        static let iconSize: CGFloat = 60
    }
    
    enum Strings {
        // Headlines Tab
        static let headlinesTitle = "Headlines"
        static let noSourcesSelected = "No sources selected"
        static let selectSourcesPrompt = "Go to Sources tab to select news sources"
        static let loadingHeadlines = "Loading headlines..."
        static let noArticlesAvailable = "No articles available"
        static let tryDifferentSources = "Try selecting different sources"
        
        // Sources Tab
        static let sourcesTitle = "Sources"
        static let loadingSources = "Loading sources..."
        static let noSourcesAvailable = "No sources available"
        
        // Saved Tab
        static let savedTitle = "Saved"
        static let noSavedArticles = "No saved articles"
        static let saveArticlesPrompt = "Save articles from the Headlines tab"
        
        // Common
        static let invalidURL = "Invalid URL"
    }
    
    enum Images {
        static let newspaper = "newspaper"
        static let documentText = "doc.text"
        static let wifiSlash = "wifi.slash"
        static let bookmark = "bookmark"
        static let bookmarkFill = "bookmark.fill"
        static let checkmarkCircleFill = "checkmark.circle.fill"
        static let listBullet = "list.bullet"
    }
}
