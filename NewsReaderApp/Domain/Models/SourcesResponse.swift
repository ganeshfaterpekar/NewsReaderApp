//
//  Sources.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 2/1/2026.
//


struct Sources: Decodable, Identifiable,Equatable {
    let id: String
    let name: String
}

struct SourcesResponse: Decodable {
    let status: String
    let sources: [Sources]
}
