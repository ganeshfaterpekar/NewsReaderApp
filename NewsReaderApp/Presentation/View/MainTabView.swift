//
//  MainTabView.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 1/1/2026.
//
import SwiftUI

struct MainTabView: View {
    
    @Environment(\.appContainer) private var container
    
    var body: some View {
        TabView {
            HeadlinesView(viewModel: HeadlinesViewModel(newsService: container.newsService, sourcesStore: container.sourcesStore, savedStore: container.savedArticlesStore))
                .tabItem { Label("Headlines", systemImage: "newspaper")}
            SourceView(viewModel: .init(newsService: container.newsService, sourcesStore: container.sourcesStore))
                .tabItem { Label ("Sources",systemImage: "list.bullet")}
            SavedView(viewModel: SavedArticlesViewModel(savedArticleStore: container.savedArticlesStore))
                .tabItem { Label ("Saved", systemImage: "bookmark")}
        }
    }
}



#Preview {
    MainTabView()
}
