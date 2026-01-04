//
//  SourcesViewModelTests.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 5/1/2026.
//

import XCTest
@testable import NewsReaderApp

@MainActor
final class SourcesViewModelTests: XCTestCase {

    func test_init_loadsSelectedSourceIds_fromStore() {
        let service = MockNewsService()
        let store = MockSourcesStore()
        store.storedSourceIds = ["bbc-news", "cnn"]

        let vm = SourcesViewModel(newsService: service, sourcesStore: store)

        XCTAssertEqual(vm.selectedSourceIds, Set(["bbc-news", "cnn"]))
    }

    func test_load_setsSources_fromService() async {
        let service = MockNewsService()
        let store = MockSourcesStore()

        service.sourcesToReturn = [
            Sources(id: "bbc-news", name: "BBC News"),
            Sources(id: "cnn", name: "CNN")
        ]

        let vm = SourcesViewModel(newsService: service, sourcesStore: store)

        await vm.load()

        XCTAssertEqual(service.fetchSourcesCallCount, 1)
        XCTAssertEqual(vm.sources, service.sourcesToReturn)
    }

    func test_toggleSelection_inserts_andPersists() {
        let service = MockNewsService()
        let store = MockSourcesStore()
        store.storedSourceIds = ["bbc-news"]

        let vm = SourcesViewModel(newsService: service, sourcesStore: store)

        vm.toggleSelection(sourceId: "cnn")

        XCTAssertEqual(vm.selectedSourceIds, Set(["bbc-news", "cnn"]))
        XCTAssertEqual(store.saveCalls.count, 1)
        XCTAssertEqual(Set(store.saveCalls.first!), Set(["bbc-news", "cnn"]))
    }

    func test_toggleSelection_removes_andPersists() {
        let service = MockNewsService()
        let store = MockSourcesStore()
        store.storedSourceIds = ["bbc-news", "cnn"]

        let vm = SourcesViewModel(newsService: service, sourcesStore: store)

        vm.toggleSelection(sourceId: "cnn")

        XCTAssertEqual(vm.selectedSourceIds, ["bbc-news"])
        XCTAssertEqual(store.saveCalls.count, 1)
        XCTAssertEqual(store.saveCalls.first!, ["bbc-news"])
    }

    func test_clearSelection_persistsEmpty() {
        let service = MockNewsService()
        let store = MockSourcesStore()
        store.storedSourceIds = ["bbc-news", "cnn"]

        let vm = SourcesViewModel(newsService: service, sourcesStore: store)

        vm.clearSelection()

        XCTAssertEqual(vm.selectedSourceIds, [])
        XCTAssertEqual(store.saveCalls.count, 1)
        XCTAssertEqual(store.saveCalls.first!, [])
    }
}
