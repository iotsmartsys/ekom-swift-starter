import SwiftUI

struct ItemsView: View {
    @EnvironmentObject private var viewModel: ItemsViewModel

    @State private var searchText: String = ""
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    @State private var itemToDelete: Item?
    @State private var formMode: ItemFormMode?

    var body: some View {
        ToastContainer(showToast: $showToast, toastMessage: toastMessage) {
            content
        }
        .navigationTitle("Itens")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Pesquisar itens")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    formMode = .create
                } label: {
                    Label("Novo item", systemImage: "plus")
                }
            }
        }
        .onChange(of: viewModel.isLoading) { _, loading in
            if !loading, let message = viewModel.errorMessage { showError(message) }
        }
        .sheet(item: $formMode) { mode in
            ItemFormView(
                title: mode.title,
                initialData: mode.formData,
                isSaving: viewModel.isSaving
            ) { submitted in
                submit(formData: submitted)
            }
        }
        .alert(item: $itemToDelete) { item in
            Alert(
                title: Text("Tem certeza que deseja excluir?"),
                message: Text(item.name),
                primaryButton: .destructive(Text("Excluir")) {
                    delete(item: item)
                },
                secondaryButton: .cancel()
            )
        }
    }

    private var content: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Carregando itens...")
            } else {
                List {
                    ForEach(filteredItems) { item in
                        itemRow(item)
                    }
                }
                .refreshable {
                    await withCheckedContinuation { continuation in
                        viewModel.loadItems { continuation.resume() }
                    }
                }
                .overlay { if filteredItems.isEmpty { ContentUnavailableView("Nenhum item", systemImage: "tray") } }
            }
        }
    }

    private func itemRow(_ item: Item) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.body)
                    Text("Cadastro")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text(item.isActive ? "Ativo" : "Inativo")
                        .foregroundStyle(item.isActive ? .green : .secondary)
                }
            }

            if let desc = item.description, !desc.isEmpty {
                Text(desc)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
        .swipeActions(edge: .trailing) {
            Button {
                formMode = .edit(item)
            } label: {
                Label("Editar", systemImage: "pencil")
            }
            .tint(.blue)

            Button(role: .destructive) {
                itemToDelete = item
            } label: {
                Label("Excluir", systemImage: "trash")
            }
        }
    }

    private var filteredItems: [Item] {
        if searchText.isEmpty { return viewModel.items }
        return viewModel.items.filter { $0.searchTokens.localizedCaseInsensitiveContains(searchText) }
    }

    private func submit(formData: ItemFormData) {
        do {
            let payload = try formData.makePayload()
            if formData.isEditing {
                viewModel.updateItem(id: formData.id, payload: payload, completion: handleSaveResult)
            } else {
                viewModel.createItem(payload: payload, completion: handleSaveResult)
            }
        } catch {
            showError(error.localizedDescription)
        }
    }

    private func handleSaveResult(_ result: Result<Void, Error>) {
        switch result {
        case .success:
            formMode = nil
        case .failure(let error):
            showError(error.localizedDescription)
        }
    }

    private func delete(item: Item) {
        viewModel.deleteItem(item.id) { result in
            switch result {
            case .success: break
            case .failure(let error): showError(error.localizedDescription)
            }
        }
    }

    private func showError(_ message: String) {
        toastMessage = "Erro: \(message)"
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { showToast = false }
    }
}

private enum ItemFormMode: Identifiable {
    case create
    case edit(Item)

    var id: String {
        switch self {
        case .create: return "create"
        case .edit(let c): return c.uid
        }
    }

    var title: String {
        switch self {
        case .create: return "Novo item"
        case .edit: return "Editar item"
        }
    }

    var formData: ItemFormData {
        switch self {
        case .create: return ItemFormData()
        case .edit(let c): return ItemFormData(item: c)
        }
    }
}

#Preview {
    NavigationStack {
        ItemsView()
            .environmentObject(ItemsViewModel(load: false, items: ItemsResponse.sampleData))
    }
}
