import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingFailed(error: Error)
    case noData
    case unknown(Error)
}
