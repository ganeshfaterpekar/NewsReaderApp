//
//  UserDefaultsSourceStore.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 2/1/2026.
//
import Foundation

final class UserDefaultsSourceStore: SourcesStore {
    private let key = "selected_sources"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func saveSources(_ ids: [sourceId]) {
        defaults.set(ids, forKey: key)
    }

    func loadSources() -> [sourceId] {
        defaults.stringArray(forKey: key) ?? []
    }
}
