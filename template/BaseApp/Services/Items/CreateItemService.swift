import Foundation

class CreateItemService: HttpService {
    func create(_ payload: ItemPayload, completion: @escaping (Result<Bool, Error>) -> Void) {
        if ApiConfiguration.usesDemoData {
            ItemsDemoStore.shared.create(payload); completion(.success(true))
        } else {
            postJSON(Enviroment.itemsEndpoint, body: payload, completion: completion)
        }
    }
}
