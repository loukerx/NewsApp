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
            Group {
                if viewModel.isLoading {
                    LoadingView(message: AppConstants.Strings.loadingSources)
                } else if viewModel.sources.isEmpty {
                    VStack(spacing: AppConstants.Layout.largeSpacing) {
                        Image(systemName: AppConstants.Images.wifiSlash)
                            .font(.system(size: AppConstants.Layout.iconSize))
                            .foregroundColor(.gray)
                        Text(AppConstants.Strings.noSourcesAvailable)
                            .font(Theme.Typography.headline)
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(Theme.Typography.caption)
                                .foregroundColor(Theme.Colors.destructive)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(viewModel.sources) { source in
                        SourceRowView(
                            source: source,
                            isSelected: viewModel.selectedSources.contains(source.id),
                            onTap: {
                                viewModel.toggleSource(source.id)
                            }
                        )
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle(AppConstants.Strings.sourcesTitle)
            .refreshable {
                await viewModel.loadSources()
            }
        }
        .task {
            await viewModel.loadSources()
        }
    }
}
