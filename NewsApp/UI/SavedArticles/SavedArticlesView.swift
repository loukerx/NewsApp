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
                    VStack(spacing: 20) {
                        Image(systemName: "bookmark")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No saved articles")
                            .font(.headline)
                        Text("Save articles from the Headlines tab")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.savedArticles) { savedArticle in
                            NavigationLink(destination: SavedArticleDetailView(savedArticle: savedArticle)) {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 12) {
                                        AsyncImage(url: URL(string: savedArticle.urlToImage ?? "")) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 80, height: 80)
                                                .clipped()
                                                .cornerRadius(8)
                                        } placeholder: {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.gray.opacity(0.3))
                                                .frame(width: 80, height: 80)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(savedArticle.title)
                                                .font(.headline)
                                                .lineLimit(2)
                                            
                                            if let description = savedArticle.description {
                                                Text(description)
                                                    .font(.caption)
                                                    .lineLimit(2)
                                                    .foregroundColor(.secondary)
                                            }
                                            
                                            HStack {
                                                if let author = savedArticle.author {
                                                    Text(author)
                                                        .font(.caption2)
                                                        .foregroundColor(.secondary)
                                                }
                                                
                                                Spacer()
                                                
                                                Text(savedArticle.savedDate, style: .date)
                                                    .font(.caption2)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                    }
                                }
                                .padding(.vertical, 4)
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
            .navigationTitle("Saved")
        }
        .onAppear {
            viewModel.loadSavedArticles()
        }
    }
}
