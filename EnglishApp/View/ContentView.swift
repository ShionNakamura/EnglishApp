import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var viewModel: WordViewModel

    @State private var showingAddView = false
    @State private var showFavorites = false 

    init() {
        let context = PersistenceController.shared.container.viewContext
        _viewModel = StateObject(wrappedValue: WordViewModel(context: context))
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(showFavorites ? viewModel.words.filter { $0.isFavorite } : viewModel.words,
                        id: \.self) { word in
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("単語:").foregroundColor(.gray)
                                Text(word.word ?? "").font(.headline)
                            }
                            HStack {
                                Text("意味:").foregroundColor(.gray)
                                Text(word.meaning ?? "").font(.headline)
                            }
                            HStack {
                                Text("例文:").foregroundColor(.gray)
                                Text(word.example ?? "").font(.headline)
                            }
                        }
                        Spacer()

                        Button(action: {
                            viewModel.toggleFavorite(word)
                        }) {
                            Image(systemName: word.isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(word.isFavorite ? .red : .gray)
                                .padding(.top, 4)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.vertical, 8)
                }
                .onDelete(perform: viewModel.deleteWord)
            }
            .navigationTitle(showFavorites ? "お気に入り単語" : "単語帳一覧")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showFavorites.toggle()
                    }) {
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
}



#Preview {
    ContentView()
}
