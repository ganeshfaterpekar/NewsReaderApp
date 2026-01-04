//
//  SavedArticlesViewModel.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 2/1/2026.
//

import SwiftUI

@MainActor
class SavedArticlesViewModel: ObservableObject {
    @Published var articles: [Article] = []
    
    private let store: SavedArticlesStore
    
    init(savedArticleStore: SavedArticlesStore) {
        self.store = savedArticleStore
        load()
    }
    
    
    func load() {
       articles =  store.load()
    }
    
    func delete(at offset: IndexSet) {
        articles.remove(atOffsets: offset)
        store.saveAll(articles: articles)
    }
    
}
