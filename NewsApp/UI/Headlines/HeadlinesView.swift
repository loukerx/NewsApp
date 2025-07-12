//
//  HeadlinesView.swift
//  NewsApp
//
//  Created by Yin Hua on 12/7/2025.
//

import SwiftUI

struct HeadlinesView: View {
    @StateObject private var viewModel = HeadlinesViewModel()
    @EnvironmentObject var sourcesViewModel: SourcesViewModel
    @State private var selectedArticle: Article?
    
    var body: some View {
        NavigationView {
            Group {
                if sourcesViewModel.selectedSources.isEmpty {
                    EmptyStateView(
                        icon: AppConstants.Images.newspaper,
                        title: AppConstants.Strings.noSourcesSelected,
                        subtitle: AppConstants.Strings.selectSourcesPrompt
                    )
                } else if viewModel.isLoading {
                    LoadingView(message: AppConstants.Strings.loadingHeadlines)
                } else if viewModel.articles.isEmpty {
                    EmptyStateView(
                        icon: AppConstants.Images.documentText,
                        title: AppConstants.Strings.noArticlesAvailable,
                        subtitle: AppConstants.Strings.tryDifferentSources
                    )
                } else {
                    List(viewModel.articles) { article in
                        NavigationLink(destination: ArticleDetailView(article: article)) {
                            ArticleRowView(
                                article: article,
                                isSaved: viewModel.isArticleSaved(article),
                                onSave: {
                                    viewModel.saveArticle(article)
                                    // Force UI update
                                    viewModel.objectWillChange.send()
                                }
                            )
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle(AppConstants.Strings.headlinesTitle)
            .refreshable {
                await viewModel.loadHeadlines(for: sourcesViewModel.selectedSources)
            }
        }
        .task {
            await viewModel.loadHeadlines(for: sourcesViewModel.selectedSources)
        }
        .onChange(of: sourcesViewModel.selectedSources) { _ in
            Task {
                await viewModel.loadHeadlines(for: sourcesViewModel.selectedSources)
            }
        }
    }
}
