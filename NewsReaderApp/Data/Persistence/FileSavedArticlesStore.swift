//
//  FileSavedArticlesStore.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 2/1/2026.
//

import Foundation

class FileSavedArticlesStore: SavedArticlesStore {
    
    private let url: URL = {
        let documentsURL = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first!

        return documentsURL.appending(
            path: "saved_articles.json",
            directoryHint: .notDirectory
        )
    }()
    
    
    func load() -> [Article] {
        guard let data =  try? Data(contentsOf: url) else { return [] }
        return (try? JSONDecoder().decode([Article].self, from: data)) ?? []
    }
    
    func save(article: Article) {
      var existing = load()
      if existing.contains(where: { $0.url == article.url }) { return }
       existing.insert(article, at: 0)
       saveAll(articles: existing)
    }
    
    func saveAll(articles: [Article]) {
        do {
            let data = try JSONEncoder().encode(articles)
            try data.write(to: url, options: [.atomic])
        } catch {
            print("Failed to save articles: \(error)")
        }
    }
    func delete(articleId: String) {
        var existing = load()
        existing.removeAll { $0.id == articleId }
        saveAll(articles: existing)
    }
    
    func savedIds() -> Set<String> {
        Set(load().map(\.id))
    }
    
    func isSaved(articleId: String) -> Bool {
        savedIds().contains(articleId)
    }

}
