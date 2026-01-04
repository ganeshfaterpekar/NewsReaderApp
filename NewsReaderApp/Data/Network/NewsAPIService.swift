//
//  NewsServiceAPI.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 2/1/2026.
//

import Foundation

class  NewsAPIService {
    
    private let session = URLSession.shared
    
    func fetchSources() async throws -> [Sources] {
        let url = URL(string:
                        "https://newsapi.org/v2/sources?language=en&apiKey=\(Configuration.newsAPIKey)")!
        let (data, error ) = try await session.data(from: url)
        return try JSONDecoder()
                   .decode([Sources].self, from: data)
    }
    
    func fetchHeadlines(sources: [sourceId]) async throws -> [Article] {
        let url = URL(string:
                  "https://newsapi.org/v2/top-headlines?sources=\(sources)&apiKey=\(Configuration.newsAPIKey)")!
        let (data,errror) = try await session.data(from: url)
        let json = try JSONDecoder()
            .decode(TopHeadlinesResponse.self, from: data)
        return json.articles.compactMap { $0.toDomain()}
            
    }
            
}
