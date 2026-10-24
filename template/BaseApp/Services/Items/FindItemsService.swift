import Foundation

class FindItemsService: HttpService {
    func fetch(completion: @escaping (Result<ItemsResponse, Error>) -> Void) {
        if ApiConfiguration.usesDemoData {
            completion(.success(ItemsDemoStore.shared.items))
        } else {
            getData(Enviroment.itemsEndpoint, completion: completion)
        }
    }
}
