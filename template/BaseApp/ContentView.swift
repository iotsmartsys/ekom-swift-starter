import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "Novo projeto",
                systemImage: "square.stack.3d.up",
                description: Text("Substitua esta tela pelo primeiro fluxo do seu app.")
            )
            .navigationTitle("BaseApp")
        }
    }
}

#Preview {
    ContentView()
}
