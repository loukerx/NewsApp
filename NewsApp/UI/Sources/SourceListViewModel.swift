//
//  SourceListViewModel.swift
//  NewsApp
//
//  Created by Yin Hua on 12/7/2025.
//

import SwiftUI
import Combine

@MainActor
class SourcesViewModel: ObservableObject {
    @Published var sources: [NewsSource] = []
    @Published var selectedSources: Set<String> = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService: NewsAPIServiceProtocol
    private let storageManager = StorageManager.shared
    
    init(apiService: NewsAPIServiceProtocol = NewsAPIService.shared) {
        self.apiService = apiService
        loadSelectedSources()
    }
    
    func loadSources() async {
        isLoading = true
        errorMessage = nil
        
        do {
            sources = try await apiService.fetchSources()
        } catch {
            errorMessage = "Failed to load sources: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func toggleSource(_ sourceId: String) {
        if selectedSources.contains(sourceId) {
            selectedSources.remove(sourceId)
        } else {
            selectedSources.insert(sourceId)
        }
        saveSelectedSources()
    }
    
    private func loadSelectedSources() {
        selectedSources = storageManager.loadSelectedSources()
    }
    
    private func saveSelectedSources() {
        storageManager.saveSelectedSources(selectedSources)
    }
}
