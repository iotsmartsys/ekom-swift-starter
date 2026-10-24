import SwiftUI

struct ItemFormView: View {
    @Environment(\.dismiss) private var dismiss

    let title: String
    let isSaving: Bool
    let onSubmit: (ItemFormData) -> Void

    @State private var formData: ItemFormData
    @State private var localErrorMessage: String?

    init(
        title: String,
        initialData: ItemFormData,
        isSaving: Bool = false,
        onSubmit: @escaping (ItemFormData) -> Void
    ) {
        self.title = title
        self.isSaving = isSaving
        self.onSubmit = onSubmit
        _formData = State(initialValue: initialData)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Identificação") {
                    TextField("Nome", text: $formData.name)


                    Toggle("Ativo", isOn: $formData.isActive)
                }

                Section("Detalhes") {
                    TextField("Descrição", text: $formData.description, axis: .vertical)
                        .lineLimit(2...4)
                }

                if let localErrorMessage {
                    Section { Text(localErrorMessage).font(.caption).foregroundStyle(.red) }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button(formData.isEditing ? "Salvar" : "Criar") {
                        do {
                            _ = try formData.makePayload()
                            localErrorMessage = nil
                            onSubmit(formData)
                        } catch {
                            localErrorMessage = error.localizedDescription
                        }
                    }
                    .disabled(isSaving)
                    .overlay { if isSaving { ProgressView() } }
                }
            }
        }
    }
}

#Preview {
    ItemFormView(title: "Novo item", initialData: ItemFormData(), onSubmit: { _ in })
}
