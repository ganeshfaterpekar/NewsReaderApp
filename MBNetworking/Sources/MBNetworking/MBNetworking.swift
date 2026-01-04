// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public protocol HTTPClient {
    func send<T: Decodable>(
        _ request: HTTPRequest,
        decodeTo type: T.Type
    ) async throws -> T
}

public struct HTTPRequest {
    let scheme: String = "https"
    let host: String
    let path: String
    let queryItems: [URLQueryItem]
    let headers: [String: String] = [:]
    let timeout: TimeInterval = 30
    
    public init(host: String, path: String, queryItems: [URLQueryItem]) {
        self.host = host
        self.path = path
        self.queryItems = queryItems
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case httpStatus(Int)
    case decoding(Error)
}

// MARK: - URLSession.shared Client

public class URLSessionSharedHTTPClient: HTTPClient {
    
    public init(){}
    
    public func send<T: Decodable>(
        _ request: HTTPRequest,
        decodeTo type: T.Type
    ) async throws -> T {

        var components = URLComponents()
        components.scheme = request.scheme
        components.host = request.host
        components.path = request.path
        components.queryItems = request.queryItems

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = request.timeout
        request.headers.forEach {
            urlRequest.setValue($1, forHTTPHeaderField: $0)
        }

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await URLSession.shared.data(for: urlRequest)
        } catch {
            throw error
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpStatus(httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }
}
