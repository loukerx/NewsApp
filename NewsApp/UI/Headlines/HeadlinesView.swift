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
                    VStack(spacing: 20) {
                        Image(systemName: "newspaper")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No sources selected")
                            .font(.headline)
                        Text("Go to Sources tab to select news sources")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.isLoading {
                    ProgressView("Loading headlines...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.articles.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No articles available")
                            .font(.headline)
                        Text("Try selecting different sources")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
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
            .navigationTitle("Headlines")
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
