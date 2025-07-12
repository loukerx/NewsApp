//
//  SourceListView.swift
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
                    ProgressView("Loading sources...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.sources.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "wifi.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No sources available")
                            .font(.headline)
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(viewModel.sources) { source in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(source.name)
                                    .font(.headline)
                                Text(source.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                            }
                            
                            Spacer()
                            
                            if viewModel.selectedSources.contains(source.id) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.toggleSource(source.id)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Sources")
            .refreshable {
                await viewModel.loadSources()
            }
        }
        .task {
            await viewModel.loadSources()
        }
    }
}
