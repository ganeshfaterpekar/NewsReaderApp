//
//  Article.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 2/1/2026.
//

import Foundation

struct ArticlePayload: Decodable {
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
}

struct Article: Codable, Identifiable, Equatable {
    var id: String
    let author: String
    let title: String
    let description: String
    let url: URL
    let imageUrl: URL?
    
    init?(payload: ArticlePayload) {
        guard
            let title = payload.title,
            let description = payload.description,
            let url = payload.url.flatMap(URL.init)
        else  { return nil }
        
        self.id = url.absoluteString
        self.author = payload.author ?? ""
        self.title = title
        self.description = description
        self.url = url
        self.imageUrl = payload.urlToImage.flatMap(URL.init)
    }
    
}

extension ArticlePayload {
    func toDomain() -> Article? {
        return .init(payload: self)
    }
}
