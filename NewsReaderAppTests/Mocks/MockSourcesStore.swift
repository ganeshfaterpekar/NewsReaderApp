//
//  MockSourcesStore.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 5/1/2026.
//

import Foundation
@testable import NewsReaderApp

final class MockSourcesStore: SourcesStore {
    var storedSourceIds: [sourceId] = []
     private(set) var saveCalls: [[sourceId]] = []

    func loadSources() -> [sourceId] {
        storedSourceIds
    }

    func saveSources(_ ids: [sourceId]) {
        saveCalls.append(ids)
        storedSourceIds = ids
    }
}
