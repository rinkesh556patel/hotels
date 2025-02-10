struct PaginatedResponse<T: Codable>: Codable {
    let items: [T]
    let metadata: Metadata
    
    struct Metadata: Codable {
        let per: Int
        let page: Int
        let total: Int
    }
} 
