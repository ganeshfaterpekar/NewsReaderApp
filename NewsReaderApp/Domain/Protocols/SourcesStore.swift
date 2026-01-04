//
//  SourceStore.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 2/1/2026.
//

import Foundation

typealias sourceId = String

protocol SourcesStore {
    func saveSources(_ ids : [sourceId])
    func loadSources() -> [sourceId]
}
