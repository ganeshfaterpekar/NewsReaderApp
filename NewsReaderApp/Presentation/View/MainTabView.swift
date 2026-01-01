//
//  MainTabView.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 1/1/2026.
//
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HeadlinesView()
                .tabItem { Label("Headlines", systemImage: "newspaper")}
            SourceView()
                .tabItem { Label ("Sources",systemImage: "list.bullet")}
            SavedView()
                .tabItem { Label ("Saved", systemImage: "bookmark")}
        }
    }
}



#Preview {
    MainTabView()
}
