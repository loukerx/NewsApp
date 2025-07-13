//
//  SourcesView.swift
//  NewsApp
//
//  Created by Yin Hua on 12/7/2025.
//

import SwiftUI

struct SourcesView: View {
    @StateObject private var viewModel = SourcesViewModel()

    var body: some View {
        NavigationView {
            List {
                contentView
            }
            .listStyle(PlainListStyle())
            .navigationTitle(AppConstants.Strings.sourcesTitle)
            .refreshable {
                await viewModel.loadSources(forceFetch: true)
            }
        }
        .task {
            await viewModel.loadSources()
        }
    }

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .loading:
            LoadingView(message: AppConstants.Strings.loadingSources)
        case .loaded(let sources):
            ForEach(sources) { source in
                SourceRowView(
                    source: source,
                    isSelected: viewModel.selectedSources.contains(source.id),
                    onTap: {
                        viewModel.toggleSource(source.id)
                    }
                )
            }
        case .empty:
            EmptyStateView(
                icon: AppConstants.Images.documentText,
                title: AppConstants.Strings.noSourcesAvailable,
                subtitle: AppConstants.Strings.tryLater
            )
        case .error(let errorMsg):
            EmptyStateView(
                icon: AppConstants.Images.wifiSlash,
                title: AppConstants.Strings.errorTitle,
                subtitle: errorMsg
            )
        }
    }
}
