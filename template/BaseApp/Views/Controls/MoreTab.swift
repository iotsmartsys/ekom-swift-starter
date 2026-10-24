import SwiftUI

struct MoreTabsView: View {
    @EnvironmentObject private var viewModel: ItemsViewModel
    var body: some View {
        List {
            Section("Geral") {
                NavigationLink { ItemsView().environmentObject(viewModel) } label: {
                    Label("Itens", systemImage: "folder")
                }
            }
            Section("Configurações") { Text("Adicione as configurações do novo produto.").foregroundStyle(.secondary) }
        }.navigationTitle("Menu")
    }
}

#Preview {
    NavigationStack { MoreTabsView().environmentObject(ItemsViewModel(load: false, items: ItemsResponse.sampleData)) }
}
