
import SwiftUI

struct ToastContainer<Content: View>: View {
    @Binding var showToast: Bool
    let toastMessage: String
    let content: () -> Content

    var body: some View {
        ZStack {
            content()
            if showToast {
                VStack {
                    Spacer()
                    Text(toastMessage)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .shadow(radius: 6)
                        .padding(.bottom, 48)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut, value: showToast)
            }
        }
    }
}

#Preview {
    ToastContainer(showToast: .constant(true), toastMessage: "Erro: Exemplo de mensagem") { Text("Conteúdo") }
}
