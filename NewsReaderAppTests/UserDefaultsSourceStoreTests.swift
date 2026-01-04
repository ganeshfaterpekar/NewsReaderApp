//
//  UserDefaultsSourceStoreTests.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 5/1/2026.
//

import XCTest
@testable import NewsReaderApp

final class UserDefaultsSourceStoreTests: XCTestCase {

    private var defaults: UserDefaults!
    private var store: UserDefaultsSourceStore!

    override func setUp() {
        super.setUp()

        // Isolated suite for tests
        defaults = UserDefaults(suiteName: "UserDefaultsSourceStoreTests")
        defaults.removePersistentDomain(forName: "UserDefaultsSourceStoreTests")

        store = UserDefaultsSourceStore(defaults: defaults)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: "UserDefaultsSourceStoreTests")
        defaults = nil
        store = nil
        super.tearDown()
    }

    func test_loadSources_returnsEmpty_whenNothingSaved() {
        // When
        let result = store.loadSources()

        // Then
        XCTAssertEqual(result, [])
    }

    func test_saveSources_thenLoadSources_returnsSavedValues() {
        // Given
        let ids: [sourceId] = ["bbc-news", "cnn", "the-verge"]

        // When
        store.saveSources(ids)
        let result = store.loadSources()

        // Then
        XCTAssertEqual(result, ids)
    }

    func test_saveSources_overwritesPreviousValues() {
        // Given
        store.saveSources(["bbc-news"])

        // When
        store.saveSources(["cnn", "the-verge"])
        let result = store.loadSources()

        // Then
        XCTAssertEqual(result, ["cnn", "the-verge"])
    }

    func test_saveSources_emptyArray_clearsStoredValues() {
        // Given
        store.saveSources(["bbc-news", "cnn"])

        // When
        store.saveSources([])
        let result = store.loadSources()

        // Then
        XCTAssertEqual(result, [])
    }
}
