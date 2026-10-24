import Foundation

/// Estado em memória compartilhado pelos services durante a demonstração.
final class ItemsDemoStore {
    static let shared = ItemsDemoStore()
    var items: ItemsResponse = ItemsResponse.sampleData
    func create(_ payload: ItemPayload) {
        items.append(Item(id: (items.compactMap(\.id).max() ?? 0) + 1, name: payload.name, description: payload.description, isActive: payload.isActive))
    }
    func update(_ id: Int, payload: ItemPayload) {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        items[index] = Item(id: id, name: payload.name, description: payload.description, isActive: payload.isActive)
    }
}
