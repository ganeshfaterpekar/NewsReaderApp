//
//  HeadlinesViewModel.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 2/1/2026.
//

import Foundation
import SwiftUI

@MainActor
class HeadlinesViewModel: ObservableObject {

    @Published private(set) var articles: [Article] = []
    @Published private(set) var isEmpty = false
    @Published private(set) var savedIds: Set<String> = []

    
    private var newsService: NewsService
    private var sourcesStore: SourcesStore
    private var savedStore: SavedArticlesStore
    
    init(newsService: NewsService, sourcesStore: SourcesStore, savedStore: SavedArticlesStore) {
        self.newsService = newsService
        self.sourcesStore = sourcesStore
        self.savedStore = savedStore
        self.savedIds = savedStore.savedIds()
    }
    
    func load() async {
     let sources =  sourcesStore.loadSources()
     articles =  (try? await newsService.fetchHeadlines(sources)) ?? []
     isEmpty = articles.isEmpty
    }
    
    func save(_ article: Article) {
        if savedIds.contains(article.id) {
           savedStore.delete(articleId: article.id)
           savedIds.remove(article.id)
        }
        else {
            savedStore.save(article: article)
            savedIds.insert(article.id)
        }
    }
    
    func isSaved(_ article: Article) -> Bool {
        savedIds.contains(article.id)
    }
    
    func syncSavedIds() {
        savedIds = savedStore.savedIds()
    }
    
}
