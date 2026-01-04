//
//  UserDefaultsSourceStore.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 2/1/2026.
//
import Foundation

class UserDefaultsSourceStore: SourcesStore {
    private let key = "selected_sources"
    
    func saveSources(_ ids: [sourceId]) {
        UserDefaults.standard.set(ids, forKey: key)
    }
    
    func loadSources() -> [sourceId] {
        UserDefaults.standard.stringArray(forKey: key) ?? []
    }
}
