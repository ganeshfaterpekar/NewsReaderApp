//
//  MockNewsService.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 5/1/2026.
//

import Foundation
@testable import NewsReaderApp

final class MockNewsService: NewsService {

    var sourcesToReturn: [Sources] = []
    var headlinesToReturn: [Article] = []
    var errorToThrow: Error?


    private(set) var fetchSourcesCallCount = 0
    private(set) var fetchHeadlinesCallCount = 0

    func fetchSources() async throws -> [Sources] {
        fetchSourcesCallCount += 1

        if let errorToThrow {
            throw errorToThrow
        }

        return sourcesToReturn
    }

    func fetchHeadlines(_ sourcesIds: [sourceId]) async throws -> [Article] {
        fetchHeadlinesCallCount += 1

        if let errorToThrow {
            throw errorToThrow
        }

        return headlinesToReturn
    }
}
