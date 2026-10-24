import Foundation

class DeleteItemService: HttpService {
    func deleteItem(_ id: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        if ApiConfiguration.usesDemoData {
            ItemsDemoStore.shared.items.removeAll { $0.id == id }; completion(.success(true))
        } else {
            delete("\(Enviroment.itemsEndpoint)/\(id)", completion: completion)
        }
    }
}
