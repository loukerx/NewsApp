//
//  ContentView.swift
//  NewsApp
//
//  Created by Yin Hua on 12/7/2025.
//

import SwiftUI

struct ContentTabView: View {
    var body: some View {
        TabView {
            HeadlinesView()
                .tabItem {
                    Label("Headlines", systemImage: "newspaper")
                }
            SourcesView()
                .tabItem {
                    Label("Sources", systemImage: "list.bullet")
                }
            SavedArticlesView()
                .tabItem {
                    Label("Saved", systemImage: "bookmark")
                }
        }
    }
}

#Preview {
    ContentTabView()
}
