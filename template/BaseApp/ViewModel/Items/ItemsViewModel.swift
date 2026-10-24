import Combine
import Foundation

class ItemsViewModel: ObservableObject {
    @Published var items: ItemsResponse = []
    @Published var isLoading: Bool = false
    @Published var isSaving: Bool = false
    @Published var errorMessage: String?

    let findService = FindItemsService()
    let createService = CreateItemService()
    let updateService = UpdateItemService()
    let deleteService = DeleteItemService()

    init(load: Bool = true, items: ItemsResponse = []) {
        if load {
            loadItems()
        } else {
            self.items = items
        }
    }

    func loadItems(completion: (() -> Void)? = nil) {
        isLoading = true
        errorMessage = nil

        findService.fetch { [weak self] result in
            DispatchQueue.main.async {
                defer { completion?() }
                self?.isLoading = false
                switch result {
                case .success(let items):
                    self?.items = items.sorted { lhs, rhs in
                        if lhs.isActive != rhs.isActive { return lhs.isActive && !rhs.isActive }
                        return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func createItem(
        payload: ItemPayload,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        isSaving = true
        createService.create(payload) { [weak self] result in
            DispatchQueue.main.async {
                self?.isSaving = false
                switch result {
                case .success:
                    self?.loadItems()
                    completion(.success(()))
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(.failure(error))
                }
            }
        }
    }

    func updateItem(
        id: Int?,
        payload: ItemPayload,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let id else {
            let err = NSError(domain: "ItemsViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "ID inválido"]) as Error
            completion(.failure(err))
            return
        }

        isSaving = true
        updateService.update(id, payload: payload) { [weak self] result in
            DispatchQueue.main.async {
                self?.isSaving = false
                switch result {
                case .success:
                    self?.loadItems()
                    completion(.success(()))
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(.failure(error))
                }
            }
        }
    }

    func deleteItem(_ id: Int?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let id else {
            let err = NSError(domain: "ItemsViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "ID inválido"]) as Error
            completion(.failure(err))
            return
        }

        deleteService.deleteItem(id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.items.removeAll { $0.id == id }
                    completion(.success(()))
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(.failure(error))
                }
            }
        }
    }
}
