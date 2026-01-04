//
//  HeadlinesViewModelTests.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 5/1/2026.
//

import XCTest
@testable import NewsReaderApp

@MainActor
final class HeadlinesViewModelTests: XCTestCase {

    private var newsService: MockNewsService!
    private var sourcesStore: MockSourcesStore!
    private var savedStore: MockSavedArticlesStore!

    override func setUp() {
        super.setUp()
        newsService = MockNewsService()
        sourcesStore = MockSourcesStore()
        savedStore = MockSavedArticlesStore()
    }

    override func tearDown() {
        newsService = nil
        sourcesStore = nil
        savedStore = nil
        super.tearDown()
    }

    private func makeArticle(url: String) -> Article {
        let payload = ArticlePayload(
            author: "Author",
            title: "Title \(url)",
            description: "Description",
            url: url,
            urlToImage: "https://example.com/image.jpg"
        )
        return Article(payload: payload)!
    }

    func test_init_seedsSavedIds_fromSavedStore() {
        let a1 = makeArticle(url: "https://example.com/1")
        let a2 = makeArticle(url: "https://example.com/2")
        savedStore.saveAll(articles: [a1, a2])

        let vm = HeadlinesViewModel(
            newsService: newsService,
            sourcesStore: sourcesStore,
            savedStore: savedStore
        )

        XCTAssertEqual(vm.savedIds, Set([a1.id, a2.id]))
    }

    func test_load_fetchesHeadlines_usingSourcesFromStore_andSetsIsEmptyFalse() async {
        sourcesStore.storedSourceIds = ["bbc-news", "cnn"]

        let a1 = makeArticle(url: "https://example.com/1")
        let a2 = makeArticle(url: "https://example.com/2")
        newsService.headlinesToReturn = [a1, a2]

        let vm = HeadlinesViewModel(
            newsService: newsService,
            sourcesStore: sourcesStore,
            savedStore: savedStore
        )

        await vm.load()

        XCTAssertEqual(newsService.fetchHeadlinesCallCount, 1)
        XCTAssertEqual(vm.articles, [a1, a2])
        XCTAssertFalse(vm.isEmpty)
    }

    func test_load_setsIsEmptyTrue_whenServiceReturnsEmpty() async {
        sourcesStore.storedSourceIds = ["bbc-news"]

        newsService.headlinesToReturn = []

        let vm = HeadlinesViewModel(
            newsService: newsService,
            sourcesStore: sourcesStore,
            savedStore: savedStore
        )

        await vm.load()

        XCTAssertEqual(vm.articles, [])
        XCTAssertTrue(vm.isEmpty)
    }

    func test_load_setsEmpty_whenServiceThrowsError() async {
        sourcesStore.storedSourceIds = ["bbc-news"]
        newsService.errorToThrow = URLError(.notConnectedToInternet)

        let vm = HeadlinesViewModel(
            newsService: newsService,
            sourcesStore: sourcesStore,
            savedStore: savedStore
        )

        await vm.load()

        XCTAssertEqual(vm.articles, [])
        XCTAssertTrue(vm.isEmpty)
    }

    func test_save_whenNotSaved_savesToStore_andAddsId() {
        let vm = HeadlinesViewModel(
            newsService: newsService,
            sourcesStore: sourcesStore,
            savedStore: savedStore
        )

        let article = makeArticle(url: "https://example.com/1")

        XCTAssertFalse(vm.savedIds.contains(article.id))

        vm.save(article)

        XCTAssertTrue(vm.savedIds.contains(article.id))
        XCTAssertEqual(savedStore.saveArticleCalls.count, 1)
        XCTAssertEqual(savedStore.saveArticleCalls.first?.id, article.id)
    }

    func test_save_whenAlreadySaved_deletesFromStore_andRemovesId() {
        let vm = HeadlinesViewModel(
            newsService: newsService,
            sourcesStore: sourcesStore,
            savedStore: savedStore
        )

        let article = makeArticle(url: "https://example.com/1")

        // Seed as saved
        savedStore.save(article: article)
        vm.syncSavedIds()
        XCTAssertTrue(vm.savedIds.contains(article.id))

        vm.save(article)

        XCTAssertFalse(vm.savedIds.contains(article.id))
        XCTAssertEqual(savedStore.deleteCalls.count, 1)
        XCTAssertEqual(savedStore.deleteCalls.first, article.id)
    }

    func test_isSaved_reflectsSavedIds() {
        let vm = HeadlinesViewModel(
            newsService: newsService,
            sourcesStore: sourcesStore,
            savedStore: savedStore
        )

        let article = makeArticle(url: "https://example.com/1")

        XCTAssertFalse(vm.isSaved(article))

        vm.save(article)

        XCTAssertTrue(vm.isSaved(article))
    }

    func test_syncSavedIds_readsFromStore() {
        let vm = HeadlinesViewModel(
            newsService: newsService,
            sourcesStore: sourcesStore,
            savedStore: savedStore
        )

        let article = makeArticle(url: "https://example.com/1")

        XCTAssertFalse(vm.savedIds.contains(article.id))

        savedStore.save(article: article)
        vm.syncSavedIds()

        XCTAssertTrue(vm.savedIds.contains(article.id))
    }
}
