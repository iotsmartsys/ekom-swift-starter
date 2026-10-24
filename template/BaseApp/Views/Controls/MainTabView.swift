import SwiftUI

struct MainTabView: View {
    @StateObject private var itemsViewModel: ItemsViewModel
    @State private var selection = 0

    init(load: Bool = true) {
        _itemsViewModel = StateObject(wrappedValue: ItemsViewModel(load: load, items: ItemsResponse.sampleData))
    }

    var body: some View {
        TabView(selection: $selection) {
            NavigationStack { ItemsView().environmentObject(itemsViewModel) }
                .tabItem { Label("Itens", systemImage: "list.bullet.rectangle") }.tag(0)
            NavigationStack { MoreTabsView().environmentObject(itemsViewModel) }
                .tabItem { Label("Mais", systemImage: "ellipsis.circle") }.tag(1)
        }
    }
}

#Preview { MainTabView(load: false) }
