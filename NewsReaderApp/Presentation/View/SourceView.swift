//
//  SourceView.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 1/1/2026.
//

import SwiftUI

struct SourceView: View {
    @ObservedObject var viewModel: SourcesViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                if let message = viewModel.errorMessage {
                    ContentUnavailableView(
                        "Couldn't load sources",
                        systemImage: "exclamationmark.triangle",
                        description: Text(message))
                }
                else if viewModel.sources.isEmpty {
                    ContentUnavailableView(
                        "No Sources",
                        systemImage: "tray",
                        description: Text("No English sources avialable right now"))
                }
                else {
                    List(viewModel.sources) { source in
                        Button {
                            viewModel.toggleSelection(sourceId: source.id)
                        } label: {
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(source.name)
                                        .font(.headline)
                                }
                                Spacer()
                                
                                if viewModel.isSelected(sourceId: source.id) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .imageScale(.large)
                                } else {
                                    Image(systemName: "circle")
                                        .imageScale(.large)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }.contentShape(Rectangle())
                    }.buttonStyle(.plain)
                }
                
            }.navigationTitle("Sources")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if !viewModel.selectedSourceIds.isEmpty {
                        Button("Clear") {viewModel.clearSelection()}
                    }
                }
            }.task {await viewModel.load()}
                .refreshable {
                    await viewModel.load()
                }
        }
    }
}
