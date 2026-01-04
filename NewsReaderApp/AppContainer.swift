//
//  AppContainer.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 2/1/2026.
//
import SwiftUI



class AppContainer {
     var newsService: NewsService
     var savedArticlesStore: SavedArticlesStore
     var sourcesStore: SourcesStore
    
//    lazy var headlinesViewModel: HeadlinesViewModel = {
//        HeadlinesViewModel(newsService: newsService, sourcesStore: sourcesStore)
//    }()
//    
//    lazy var savedArticlesViewModel: SavedArticlesViewModel = {
//        SavedArticlesViewModel(savedArticleStore: savedArticlesStore)
//    }()
//    
    
    init(newsService: NewsService, savedArticlesStore: SavedArticlesStore, sourcesStore: SourcesStore) {
        self.newsService = newsService
        self.savedArticlesStore = savedArticlesStore
        self.sourcesStore = sourcesStore
    }
    
}


extension AppContainer {
    static let live = AppContainer(
        newsService: NewsAPIService(),
        savedArticlesStore: FileSavedArticlesStore(),
        sourcesStore: UserDefaultsSourceStore())
}
