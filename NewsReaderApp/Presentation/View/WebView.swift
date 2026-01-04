//
//  WebView.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 5/1/2026.
//
import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ view: WKWebView, context: Context) {
        view.load(URLRequest(url: url))
    }
}


 extension URL: Identifiable {
   public var id: String { absoluteString }
}
