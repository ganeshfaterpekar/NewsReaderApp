//
//  NewsService.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 2/1/2026.
//

protocol NewsService {
    func fetchSources() async throws -> [Sources]
    func fetchHeadlines(_ sourcesIds : [sourceId] ) async throws -> [Article]
}

