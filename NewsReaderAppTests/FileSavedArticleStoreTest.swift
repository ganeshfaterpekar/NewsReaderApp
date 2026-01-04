//
//  FileSavedArticleStoreTest.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 5/1/2026.
//

import XCTest
@testable import NewsReaderApp

final class FileSavedArticlesStoreTests: XCTestCase {

    private var fileURL: URL!
    private var store: FileSavedArticlesStore!

    override func setUp() {
        super.setUp()

        fileURL = FileManager.default.temporaryDirectory
            .appending(path: "saved_articles_\(UUID().uuidString).json", directoryHint: .notDirectory)

        store = FileSavedArticlesStore(url: fileURL)
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: fileURL)
        fileURL = nil
        store = nil
        super.tearDown()
    }

    // MARK: - Helpers

    private func makePayload(
        author: String? = "Author",
        title: String? = "Title",
        description: String? = "Description",
        url: String? = "https://example.com/article",
        urlToImage: String? = "https://example.com/image.jpg"
    ) -> ArticlePayload {
        ArticlePayload(author: author, title: title, description: description, url: url, urlToImage: urlToImage)
    }

    private func makeArticle(url: String = "https://example.com/article") -> Article {
        let payload = makePayload(url: url)
        return Article(payload: payload)! // safe for test
    }

    // MARK: - Tests

    func test_load_returnsEmpty_whenFileDoesNotExist() {
        XCTAssertEqual(store.load(), [])
    }

    func test_saveArticle_thenLoad_returnsArticle() {
        let article = makeArticle(url: "https://example.com/1")

        store.save(article: article)

        let loaded = store.load()
        XCTAssertEqual(loaded.count, 1)
        XCTAssertEqual(loaded.first, article)
        XCTAssertEqual(loaded.first?.id, article.id)
        XCTAssertEqual(loaded.first?.url, article.url)
    }

    func test_saveArticle_dedupesByURL() {
        let a1 = makeArticle(url: "https://example.com/dup")
        let a2 = makeArticle(url: "https://example.com/dup") // same URL => should dedupe

        store.save(article: a1)
        store.save(article: a2)

        let loaded = store.load()
        XCTAssertEqual(loaded.count, 1)
        XCTAssertEqual(loaded.first?.url, a1.url)
    }

    

    func test_saveAll_thenLoad_returnsSameOrder() {
        let a1 = makeArticle(url: "https://example.com/1")
        let a2 = makeArticle(url: "https://example.com/2")

        store.saveAll(articles: [a1, a2])

        let loaded = store.load()
        XCTAssertEqual(loaded, [a1, a2])
    }

    func test_delete_removesByArticleId() {
        let a1 = makeArticle(url: "https://example.com/1")
        let a2 = makeArticle(url: "https://example.com/2")

        store.saveAll(articles: [a1, a2])

        store.delete(articleId: a1.id)

        let loaded = store.load()
        XCTAssertEqual(loaded, [a2])
    }

    func test_savedIds_returnsIDsOfLoadedArticles() {
        let a1 = makeArticle(url: "https://example.com/1")
        let a2 = makeArticle(url: "https://example.com/2")

        store.saveAll(articles: [a1, a2])

        XCTAssertEqual(store.savedIds(), Set([a1.id, a2.id]))
    }

    func test_isSaved_trueWhenIdExists_falseOtherwise() {
        let a1 = makeArticle(url: "https://example.com/1")
        store.save(article: a1)

        XCTAssertTrue(store.isSaved(articleId: a1.id))
        XCTAssertFalse(store.isSaved(articleId: "https://example.com/not-saved"))
    }

    func test_load_returnsEmpty_whenFileContainsInvalidJSON() throws {
        try Data("not json".utf8).write(to: fileURL, options: [.atomic])
        XCTAssertEqual(store.load(), [])
    }

    func test_articleInitializer_returnsNil_whenMissingRequiredFields() {
        // Missing title
        XCTAssertNil(Article(payload: makePayload(title: nil)))
        // Missing description
        XCTAssertNil(Article(payload: makePayload(description: nil)))
        // Missing url
        XCTAssertNil(Article(payload: makePayload(url: nil)))
    }
}

