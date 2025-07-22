

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var viewModel: WordViewModel

    @State private var showingAddView = false
    @State private var showingReview = false


    init() {
        let context = PersistenceController.shared.container.viewContext
        _viewModel = StateObject(wrappedValue: WordViewModel(context: context))
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.words, id: \.self) { word in
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
                }
                .onDelete(perform: viewModel.deleteWord)
            }
            .navigationTitle("単語メモ")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddView = true }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                           Button(action: { showingReview = true }) {
                               Text("復習モード")
                           }
                       }
            }
            
            .sheet(isPresented: $showingAddView) {
                AddWordView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingReview) {
                ReviewTypingQuizView(viewModel: viewModel)
               }
        }
    }
}


#Preview {
    ContentView()
}
