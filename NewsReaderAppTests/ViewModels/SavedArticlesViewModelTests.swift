//
//  SavedArticlesViewModelTests.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 5/1/2026.
//

import XCTest
@testable import NewsReaderApp

@MainActor
final class SavedArticlesViewModelTests: XCTestCase {

    private var store: MockSavedArticlesStore!

    override func setUp() {
        super.setUp()
        store = MockSavedArticlesStore()
    }

    override func tearDown() {
        store = nil
        super.tearDown()
    }

    private func makeArticle(url: String) -> Article {
        let payload = ArticlePayload(
            author: "Author",
            title: "Title",
            description: "Description",
            url: url,
            urlToImage: nil
        )
        return Article(payload: payload)!
    }

    func test_init_loadsArticlesFromStore() {
        store.loadResult = [
            makeArticle(url: "https://example.com/1"),
            makeArticle(url: "https://example.com/2")
        ]

        let vm = SavedArticlesViewModel(savedArticleStore: store)

        XCTAssertEqual(vm.articles, store.loadResult)
    }

    func test_load_refreshesArticlesFromStore() {
        store.loadResult = [makeArticle(url: "https://example.com/1")]

        let vm = SavedArticlesViewModel(savedArticleStore: store)
        XCTAssertEqual(vm.articles.count, 1)

        store.loadResult = [
            makeArticle(url: "https://example.com/1"),
            makeArticle(url: "https://example.com/2")
        ]

        vm.load()

        XCTAssertEqual(vm.articles, store.loadResult)
    }

    func test_delete_removesArticleAndPersistsRemaining() {
        let a1 = makeArticle(url: "https://example.com/1")
        let a2 = makeArticle(url: "https://example.com/2")
        let a3 = makeArticle(url: "https://example.com/3")

        store.loadResult = [a1, a2, a3]

        let vm = SavedArticlesViewModel(savedArticleStore: store)

        vm.delete(at: IndexSet(integer: 1)) // delete a2

        XCTAssertEqual(vm.articles, [a1, a3])
        XCTAssertEqual(store.saveAllCalls.count, 1)
        XCTAssertEqual(store.saveAllCalls.first!, [a1, a3])
    }
}
