//
//  NewsServiceAPI.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 2/1/2026.
//

import Foundation
import MBNetworking

class NewsAPIService: NewsService {

    private let client: HTTPClient
    private let apiKey: String

    init(
        client: HTTPClient = URLSessionSharedHTTPClient(),
        apiKey: String = Configuration.newsAPIKey
    ) {
        self.client = client
        self.apiKey = apiKey
    }

    func fetchSources() async throws -> [Sources] {
        let request = HTTPRequest(
            host: "newsapi.org",
            path: "/v2/top-headlines/sources",
            queryItems: [
                URLQueryItem(name: "language", value: "en"),
                URLQueryItem(name: "apiKey", value: apiKey)
            ]
        )

        let response = try await client.send(
            request,
            decodeTo: SourcesResponse.self
        )

        return response.sources
    }

    func fetchHeadlines(_ sourcesIds: [sourceId]) async throws -> [Article] {
        guard !sourcesIds.isEmpty else { return [] }

        let sources = sourcesIds.joined(separator: ",")

        let request = HTTPRequest(
            host: "newsapi.org",
            path: "/v2/top-headlines",
            queryItems: [
                URLQueryItem(name: "sources", value: sources),
                URLQueryItem(name: "apiKey", value: apiKey)
            ]
        )

        let response = try await client.send(
            request,
            decodeTo: TopHeadlinesResponse.self
        )

        return response.articles.compactMap { $0.toDomain() }
    }
}

