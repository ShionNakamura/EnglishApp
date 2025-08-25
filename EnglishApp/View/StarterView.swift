import SwiftUI

struct StarterView: View {
    @AppStorage("currentScreen") private var currentScreen = "starter"

    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                // 学習モード
                NavigationLink(destination: ContentView()) {
                    Text("単語帳")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }

                // 復習モード
                NavigationLink(destination: {
                    let context = PersistenceController.shared.container.viewContext
                    let viewModel = WordViewModel(context: context)
                    ReviewTypingQuizView(viewModel: viewModel)
                }) {
                    Text("復習モード")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("ホーム")
        }
    }
}

#Preview {
    StarterView()
}

