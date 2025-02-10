import Foundation

class APIClient {
    static let shared = APIClient()
    private let baseURL = "http://localhost:8080"
    private var token: String?
    
    private init() {}
    
    func setToken(_ token: String) {
        self.token = token
    }
    
    func clearToken() {
        self.token = nil
    }
    
    func request<T: Codable>(_ endpoint: Endpoint) async throws -> T {
        guard let url = URL(string: baseURL + endpoint.path) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = AuthManager.shared.token {
            print("Adding auth token to request: \(token)")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = endpoint.body {
            let encoder = JSONEncoder()
            // encoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try? encoder.encode(body)
            
            // Debug print request body
            if let data = request.httpBody, let json = String(data: data, encoding: .utf8) {
                print("📤 Request body: \(json)")
            }
        }
        
        print("📡 Request: \(request.url?.absoluteString ?? "")")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.networkError(NSError(domain: "", code: -1))
            }
            
            print("📥 Response status: \(httpResponse.statusCode)")
            if let responseString = String(data: data, encoding: .utf8) {
                print("📦 Response data: \(responseString)")
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    decoder.dateDecodingStrategy = .iso8601
                    return try decoder.decode(T.self, from: data)
                } catch {
                    print("❌ Decoding error: \(error)")
                    if let decodingError = error as? DecodingError {
                        switch decodingError {
                        case .keyNotFound(let key, let context):
                            print("Key '\(key)' not found: \(context.debugDescription)")
                            print("CodingPath:", context.codingPath)
                        case .valueNotFound(let type, let context):
                            print("Value '\(type)' not found: \(context.debugDescription)")
                            print("CodingPath:", context.codingPath)
                        case .typeMismatch(let type, let context):
                            print("Type '\(type)' mismatch: \(context.debugDescription)")
                            print("CodingPath:", context.codingPath)
                        case .dataCorrupted(let context):
                            print("Data corrupted: \(context.debugDescription)")
                            print("CodingPath:", context.codingPath)
                        @unknown default:
                            print("Unknown decoding error")
                        }
                    }
                    throw APIError.decodingError(error)
                }
            case 401:
                throw APIError.unauthorized
            default:
                throw APIError.serverError("Status code: \(httpResponse.statusCode)")
            }
        } catch {
            print("❌ Network error: \(error)")
            throw APIError.networkError(error)
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

struct Endpoint {
    let path: String
    let method: HTTPMethod
    let body: Encodable?
    let encoder: JSONEncoder
    
    init(path: String,
         method: HTTPMethod = .get,
         body: Encodable? = nil,
         encoder: JSONEncoder = JSONEncoder()) {
        self.path = path
        self.method = method
        self.body = body
        self.encoder = encoder
    }
}
