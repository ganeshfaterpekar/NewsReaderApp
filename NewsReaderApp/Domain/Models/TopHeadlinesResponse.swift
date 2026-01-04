//
//  TopHeadlinesResponse.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 2/1/2026.
//

struct TopHeadlinesResponse: Decodable {
    let status: String?
    let totalResults: Int?
    var articles: [ArticlePayload] = []
    
}

struct SourcesResponse: Decodable {
    let status: String
    let sources: [Sources]
}
