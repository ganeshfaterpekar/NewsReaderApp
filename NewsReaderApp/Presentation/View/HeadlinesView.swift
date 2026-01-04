//
//  HeadlinesView.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 1/1/2026.
//
import SwiftUI
struct HeadlinesView: View {
    
    @ObservedObject var viewModel: HeadlinesViewModel
    @State private var selectedURL: URL?

    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isEmpty {
                    ContentUnavailableView(
                        "No Articles",
                        systemImage: "exclamationmark.circle",
                        description: Text("Select sources to see headlines.")
                    )
                }
                else {
//                    List(viewModel.articles) { article in
//                        NewsReaderUI.makeHeadlinesRowItemsView(articleItem: article, isSaved: viewModel.isSaved(article)){
//                            viewModel.save(article)
//                        }
//                    }
                    
                    List {
                        ForEach(viewModel.articles) { article in
                            Button {
                                selectedURL = article.url
                            } label: {
                                NewsReaderUI.makeHeadlinesRowItemsView(articleItem: article, isSaved: viewModel.isSaved(article)) {
                                    viewModel.save(article)
                                }
                            }.buttonStyle(.plain)
                            
                        }
                    }.listStyle(.plain)
                }
                
            }.navigationTitle("Headlines")
            .onAppear {
                viewModel.syncSavedIds()
            }
            .task {
                await viewModel.load()
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
            }

        }
        
    }
}
