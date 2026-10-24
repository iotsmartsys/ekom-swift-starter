import Foundation

class UpdateItemService: HttpService {
    func update(_ id: Int, payload: ItemPayload, completion: @escaping (Result<Bool, Error>) -> Void) {
        if ApiConfiguration.usesDemoData {
            ItemsDemoStore.shared.update(id, payload: payload); completion(.success(true))
        } else {
            putJSON("\(Enviroment.itemsEndpoint)/\(id)", body: payload, completion: completion)
        }
    }
}
