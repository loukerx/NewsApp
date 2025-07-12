//
//  WebView.swift
//  NewsApp
//
//  Created by Yin Hua on 12/7/2025.
//


import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL

//    func makeUIView(context: Context) -> WKWebView {
//        let webView = WKWebView()
//        let request = URLRequest(url: url)
//        webView.load(request)
//        return webView
//    }
//
//    func updateUIView(_ webView: WKWebView, context: Context) {
//        if webView.url != url {
//            webView.load(URLRequest(url: url))
//        }
//    }
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
