//
//  NewsAPIServiceTests.swift
//  NewsApp
//
//  Created by Yin Hua on 12/7/2025.
//
import XCTest
@testable import NewsApp

/// A URLProtocol stub we can configure to return Data/responses or throw errors.
private class URLProtocolStub: URLProtocol {
    /// Handler closure set by each test
    static var requestHandler: ((URLRequest) throws -> (Data, HTTPURLResponse))?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func startLoading() {
        guard let handler = URLProtocolStub.requestHandler else {
            fatalError("URLProtocolStub.requestHandler not set")
        }
        do {
            let (data, response) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    override func stopLoading() {}
}

final class NewsAPIServiceTests: XCTestCase {
    var service: NewsAPIService!
    
    override func setUp() {
        super.setUp()
        // Inject a URLSession whose config uses our stub
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: config)
        service = NewsAPIService(session: session)
    }
    
    override func tearDown() {
        URLProtocolStub.requestHandler = nil
        service = nil
        super.tearDown()
    }
    
    /// Helper to load "sources.json" or "articles.json" from the test bundle
    private func loadJSON(named name: String) -> Data {
        let bundle = Bundle(for: NewsAPIServiceTests.self)
        let url = bundle.url(forResource: name, withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    func testFetchSourcesSucceeds() async throws {
        let data = loadJSON(named: "sources")
        URLProtocolStub.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil)!
            return (data, response)
        }
        
        let sources = try await service.fetchSources()
        XCTAssertEqual(sources.count, 3, "Should parse three sources")
        XCTAssertEqual(sources[0].id, "abc-news")
        XCTAssertEqual(sources[1].id, "abc-news-au")
        XCTAssertEqual(sources[2].id, "al-jazeera-english")
    }
    
    func testFetchHeadlinesSucceeds() async throws {
        let data = loadJSON(named: "articles")
        URLProtocolStub.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil)!
            return (data, response)
        }
        
        let articles = try await service.fetchHeadlines(sources: ["bbc-news"])
        XCTAssertEqual(articles.count, 3, "Should parse three articles")
        XCTAssertEqual(articles[0].title, "Donald Trump and the Scots: A not-so special relationship")
        XCTAssertEqual(articles[1].url, "https://www.bbc.co.uk/news/articles/c17w87pv5ljo")
    }
    
    func testFetchSourcesThrowsDecodingError() async {
        let badJSON = Data("not a valid json".utf8)
        URLProtocolStub.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil)!
            return (badJSON, response)
        }
        
        do {
            _ = try await service.fetchSources()
            XCTFail("Expected decodingError but got success")
        } catch NetworkError.decodingError {
            // good
        } catch {
            XCTFail("Expected decodingError, got \(error)")
        }
    }
    
    func testFetchHeadlinesThrowsNetworkError() async {
        let underlying = URLError(.notConnectedToInternet)
        URLProtocolStub.requestHandler = { _ in throw underlying }
        
        do {
            _ = try await service.fetchHeadlines(sources: ["x"])
            XCTFail("Expected networkError but got success")
        } catch NetworkError.networkError(let msg) {
            XCTAssertEqual(msg, underlying.localizedDescription)
        } catch {
            XCTFail("Expected networkError, got \(error)")
        }
    }
}
