import Foundation

extension ItemsResponse {
    static let sampleData: ItemsResponse = {
        guard let url = Bundle.main.url(forResource: "items_sample", withExtension: "json") else {
            print("ItemsResponse.sampleData: could not find items_sample.json in bundle")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(ItemsResponse.self, from: data)
        } catch {
            print("Failed to decode ItemsResponse sample JSON:", error)
            return []
        }
    }()
}
