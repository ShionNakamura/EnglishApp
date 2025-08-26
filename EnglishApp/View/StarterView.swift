import SwiftUI

struct StarterView: View {
    @AppStorage("currentScreen") private var currentScreen = "starter"
    let context = PersistenceController.shared.container.viewContext
    @StateObject private var reviewViewModel: WordViewModel

    init() {
        let vm = WordViewModel(context: PersistenceController.shared.container.viewContext)
        _reviewViewModel = StateObject(wrappedValue: vm)
    }

    var body: some View {
        TabView {
            // 単語帳タブ
            NavigationStack {
                ContentView()
            }
            .tabItem {
                Label("単語帳", systemImage: "book")
            }

            // 復習モードタブ
            NavigationStack {
                ReviewTypingQuizView(viewModel: reviewViewModel)
            }
            .tabItem {
                Label("復習", systemImage: "repeat")
            }

            // 学習記録タブ
            NavigationStack {
                StudyLogInView()
            }
            .tabItem {
                Label("学習記録", systemImage: "chart.bar")
            }
        }
    }
}


#Preview {
    StarterView()
}
