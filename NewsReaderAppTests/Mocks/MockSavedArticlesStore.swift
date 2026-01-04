//
//  MockSavedArticlesStore.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 5/1/2026.
//

import Foundation
@testable import NewsReaderApp

final class MockSavedArticlesStore: SavedArticlesStore {
    var loadResult: [Article] = []

    private(set) var saveAllCalls: [[Article]] = []
    private(set) var saveArticleCalls: [Article] = []
    private(set) var deleteCalls: [String] = []


    func load() -> [Article] {
        loadResult
    }

    func saveAll(articles: [Article]) {
        saveAllCalls.append(articles)
        loadResult = articles
    }

    func save(article: Article) {
        saveArticleCalls.append(article)
        if !loadResult.contains(where: { $0.id == article.id }) {
            loadResult.insert(article, at: 0)
        }
    }

    func delete(articleId: String) {
        deleteCalls.append(articleId)
        loadResult.removeAll { $0.id == articleId }
    }

    func savedIds() -> Set<String> {
        Set(loadResult.map(\.id))
    }

    func isSaved(articleId: String) -> Bool {
        savedIds().contains(articleId)
    }

    func reset() {
        loadResult = []
        saveAllCalls = []
        saveArticleCalls = []
        deleteCalls = []
    }
}
