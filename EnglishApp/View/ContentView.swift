import SwiftUI
import CoreData

// MARK: - Main ContentView with TabView
struct ContentView: View {
    @StateObject private var viewModel: WordViewModel

    init() {
        let context = PersistenceController.shared.container.viewContext
        _viewModel = StateObject(wrappedValue: WordViewModel(context: context))
    }

    var body: some View {
        TabView {
            // 🔹 単語帳タブ
            NavigationView {
                WordListView(viewModel: viewModel)
            }
            .tabItem {
                Label("単語帳", systemImage: "book")
            }
            // 🔹 復習モードタブ
            NavigationView {
                ReviewTypingQuizView(viewModel: viewModel)
            }
            .tabItem {
                Label("復習", systemImage: "repeat")
            }
            // 🔹 学習記録タブ
            NavigationView {
                StudyLogInView()
            }
            .tabItem {
                Label("学習記録", systemImage: "chart.bar")
            }
            NavigationView {
                 AccountView()
             }
             .tabItem {
                 Label("アカウント", systemImage: "person.crop.circle")
             }
        }
    }
}

// MARK: - WordListView (単語帳)
struct WordListView: View {
    @ObservedObject var viewModel: WordViewModel
    @State private var showingAddView = false
    @State private var showFavorites = false

    var body: some View {
        List {
            ForEach(showFavorites ? viewModel.words.filter { $0.isFavorite } : viewModel.words,
                    id: \.self) { word in
                WordCardView(word: word, viewModel: viewModel)
                    .padding(.vertical, 4)
            }
            .onDelete(perform: viewModel.deleteWord)
        }
        .listStyle(.plain)
        .navigationTitle(showFavorites ? "お気に入り単語" : "単語帳一覧")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { showFavorites.toggle() }) {
                    Image(systemName: showFavorites ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddView = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddView) {
            AddWordView(viewModel: viewModel)
        }
    }
}

// MARK: - WordCardView
struct WordCardView: View {
    @ObservedObject var word: WordEntity
    let viewModel: WordViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(word.word ?? "")
                    .font(.title2).bold()
                Spacer()
                Button {
                    viewModel.toggleFavorite(word)
                } label: {
                    Image(systemName: word.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(word.isFavorite ? .red : .gray)
                        .font(.title3)
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Label(word.meaning ?? "", systemImage: "lightbulb")
                    .foregroundColor(.blue)
                Label(word.example ?? "", systemImage: "text.book.closed")
                    .foregroundColor(.secondary)
            }
            .font(.subheadline)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(radius: 5)
        )
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}

