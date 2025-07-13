//
//  HeadlinesView.swift
//  NewsApp
//
//  Created by Yin Hua on 12/7/2025.
//

import SwiftUI

struct HeadlinesView: View {
    @StateObject private var viewModel = HeadlinesViewModel()
    @State private var selectedArticle: Article?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if viewModel.selectedSources.isEmpty {
                        EmptyStateView(
                            icon: AppConstants.Images.newspaper,
                            title: AppConstants.Strings.noSourcesSelected,
                            subtitle: AppConstants.Strings.selectSourcesPrompt
                        )
                    } else {
                        switch viewModel.state {
                        case .loading:
                            LoadingView(message: AppConstants.Strings.loadingHeadlines)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        case .empty:
                            EmptyStateView(
                                icon: AppConstants.Images.documentText,
                                title: AppConstants.Strings.noArticlesAvailable,
                                subtitle: AppConstants.Strings.tryDifferentSources,
                            )
                        case .error(let errorMsg):
                            EmptyStateView(
                                icon: AppConstants.Images.wifiSlash,
                                title: AppConstants.Strings.errorTitle,
                                subtitle: errorMsg,
                            )
                        case .loaded(let articles):
                            if articles.isEmpty {
                                EmptyStateView(
                                    icon: AppConstants.Images.documentText,
                                    title: AppConstants.Strings.noArticlesAvailable,
                                    subtitle: AppConstants.Strings.tryDifferentSources
                                )
                            } else {
                                LazyVStack {
                                    ForEach(articles) { article in
                                        NavigationLink(destination: ArticleDetailView(article: article)) {
                                            ArticleRowView(
                                                article: article,
                                                isSaved: viewModel.isArticleSaved(article),
                                                onSave: {
                                                    viewModel.saveArticle(article)
                                                }
                                            )
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle(AppConstants.Strings.headlinesTitle)
            .refreshable {
                await viewModel.reloadHeadlines()
            }
        }
        .task {
            await viewModel.reloadHeadlines()
        }
        .onChange(of: viewModel.selectedSources) { _ in
            Task {
                await viewModel.reloadHeadlines()
            }
        }
    }
}
