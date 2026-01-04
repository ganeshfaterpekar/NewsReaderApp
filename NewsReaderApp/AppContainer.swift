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
    
    init(newsService: NewsService, savedArticlesStore: SavedArticlesStore, sourcesStore: SourcesStore) {
        self.newsService = newsService
        self.savedArticlesStore = savedArticlesStore
        self.sourcesStore = sourcesStore
    }
    
}

extension AppContainer {
    
    private static let url: URL = {
        let documentsURL = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first!

        return documentsURL.appending(
            path: "saved_articles.json",
            directoryHint: .notDirectory
        )
    }()

    static let live = AppContainer(
        newsService: NewsAPIService(),
        savedArticlesStore: FileSavedArticlesStore(url: url),
        sourcesStore: UserDefaultsSourceStore())
}
