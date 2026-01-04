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
        let result = store.loadSources()
        XCTAssertEqual(result, [])
    }

    func test_saveSources_thenLoadSources_returnsSavedValues() {
        let ids: [sourceId] = ["bbc-news", "cnn", "the-verge"]
        store.saveSources(ids)
        let result = store.loadSources()
        XCTAssertEqual(result, ids)
    }

    func test_saveSources_overwritesPreviousValues() {
        store.saveSources(["bbc-news"])
        store.saveSources(["cnn", "the-verge"])
        let result = store.loadSources()
        XCTAssertEqual(result, ["cnn", "the-verge"])
    }

    func test_saveSources_emptyArray_clearsStoredValues() {
        store.saveSources(["bbc-news", "cnn"])
        store.saveSources([])
        let result = store.loadSources()
        XCTAssertEqual(result, [])
    }
}
