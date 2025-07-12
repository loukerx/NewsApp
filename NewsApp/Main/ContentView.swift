//
//  ContentView.swift
//  NewsApp
//
//  Created by Yin Hua on 12/7/2025.
//

import SwiftUI

struct ContentTabView: View {
    @StateObject private var sourcesViewModel = SourcesViewModel()
    
    var body: some View {
        TabView {
            HeadlinesView()
                .tabItem {
                    Label("Headlines", systemImage: "newspaper")
                }
                .environmentObject(sourcesViewModel)
            
            SourcesView()
                .tabItem {
                    Label("Sources", systemImage: "list.bullet")
                }
                .environmentObject(sourcesViewModel)
            
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
