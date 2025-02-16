import Foundation

// MARK: - NewsData
struct NewsData: Decodable {
    let news: [NewsItem]
    let totalCount: Int
}

// MARK: - NewsItem
struct NewsItem: Decodable {
    let id: Int
    let title: String
    let description: String
    let publishedDate: String
    let url: String
    let fullUrl: String
    let titleImageUrl: String
    let categoryType: String
}
