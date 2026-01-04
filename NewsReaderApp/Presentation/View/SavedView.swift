//
//  SavedView.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 1/1/2026.
//
import SwiftUI
import WebKit


struct SavedView: View {
    @ObservedObject var viewModel: SavedArticlesViewModel
    @State private var selectedURL: URL?
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.articles.isEmpty {
                    ContentUnavailableView(
                        "No Saved Articles",
                        systemImage: "bookmark",
                        description: Text("Save articles from Headlines to see them here.")
                    )
                } else {
                    List {
                        ForEach(viewModel.articles) { article in
                            Button {
                                selectedURL = article.url
                            } label: {
                                NewsReaderUI.makeSavedRowItemsView(articleItem: article)
                            }.buttonStyle(.plain)
                            
                        }.onDelete { indexSet in
                            viewModel.delete(at: indexSet)
                        }
                    }.listStyle(.plain)
                }
            }
            .navigationTitle("Saved")
            .toolbar {
               ToolbarItem(placement: .topBarTrailing) {
                  if !viewModel.articles.isEmpty {
                      EditButton()
                }
               }
            }.sheet(item: $selectedURL) { url in
                NavigationStack {
                    WebView(url: url)
                        .navigationTitle("Article")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("Done") { selectedURL = nil }
                            }
                        }
                }
            }.onAppear {
                viewModel.load()
            }
        }
    }
}
