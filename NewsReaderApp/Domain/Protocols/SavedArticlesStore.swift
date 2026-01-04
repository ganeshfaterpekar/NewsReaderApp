//
//  SavedArticlesStore.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 2/1/2026.
//

protocol SavedArticlesStore {
    func load() -> [Article]
    func save(article: Article)
    func saveAll(articles: [Article])
    func delete(articleId: String)
    func savedIds() -> Set<String>
    func isSaved(articleId: String) -> Bool
}
