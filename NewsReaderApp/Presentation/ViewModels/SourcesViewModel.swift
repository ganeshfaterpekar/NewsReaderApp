//
//  SourcesViewModel.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 2/1/2026.
//

import SwiftUI

@MainActor
class SourcesViewModel: ObservableObject {
    @Published var sources: [Sources] = []
    @Published var selectedSourceIds: Set <String>
    @Published var errorMessage: String? = nil
    
    private let service: NewsService
    private let store: SourcesStore
    
    init(newsService: NewsService, sourcesStore: SourcesStore) {
        self.service = newsService
        self.store = sourcesStore
        self.selectedSourceIds = Set(store.loadSources())
    }
    
    func load() async  {
       sources =  (try? await service.fetchSources()) ?? []
    }
    
    func isSelected(sourceId: String) -> Bool {
        selectedSourceIds.contains(sourceId)
    }
    
    //TODO:
    func toggleSelection(sourceId: String) {
        if selectedSourceIds.contains(sourceId) {
            selectedSourceIds.remove(sourceId)
        } else {
            selectedSourceIds.insert(sourceId)
        }
       store.saveSources(Array(selectedSourceIds))
    }

    func clearSelection() {
        selectedSourceIds.removeAll()
        store.saveSources([])
    }
    
}
