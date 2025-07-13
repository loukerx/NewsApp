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
    enum SourcesState {
        case loading
        case loaded([NewsSource])
        case empty
        case error(String)
    }

    @Published var selectedSources: Set<String> = []
    @Published var state: SourcesState = .loading

    private let storageManager = StorageManager.shared
    private let repository: NewsRepositoryProtocol
    
    init(repository: NewsRepositoryProtocol = NewsRepository()) {
        self.repository = repository
        loadSelectedSources()
    }

    func loadSources(forceFetch: Bool = false) async {
        state = .loading
        
        do {
            let sources = try await repository.fetchSources(forceFetch: forceFetch)
            if sources.isEmpty {
                state = .empty
            } else {
                state = .loaded(sources)
            }
        } catch {
            state = .error(AppConstants.Strings.networkErrorSources)
        }
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
