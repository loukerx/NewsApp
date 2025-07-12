//
//  SavedArticlesView.swift
//  NewsApp
//
//  Created by Yin Hua on 12/7/2025.
//

import SwiftUI

struct SavedArticlesView: View {
    @StateObject private var viewModel = SavedArticlesViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.savedArticles.isEmpty {
                    EmptyStateView(
                        icon: AppConstants.Images.bookmark,
                        title: AppConstants.Strings.noSavedArticles,
                        subtitle: AppConstants.Strings.saveArticlesPrompt
                    )
                } else {
                    List {
                        ForEach(viewModel.savedArticles) { savedArticle in
                            NavigationLink(destination: SavedArticleDetailView(savedArticle: savedArticle)) {
                                SavedArticleRowView(savedArticle: savedArticle)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                viewModel.removeArticle(viewModel.savedArticles[index])
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle(AppConstants.Strings.savedTitle)
        }
        .onAppear {
            viewModel.loadSavedArticles()
        }
    }
}
