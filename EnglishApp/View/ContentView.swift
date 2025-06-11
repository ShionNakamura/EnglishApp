

import SwiftUI

struct ContentView: View {
    @StateObject  var viewModel = WordViewModel()
    @State  var showingAddView = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.words) { word in
                    VStack(alignment: .leading,spacing: 10) {
                        HStack {
                        Text("単語:")
                            .foregroundColor(.gray)

                        Text(word.word)
                            .font(.headline)
                        }
                        HStack {
                            Text("意味:")
                                .foregroundColor(.gray)
                            Text(word.meaning)
                                .font(.headline)
                        }
                        HStack {
                            Text("例文:")
                                .foregroundColor(.gray)
                            Text(word.example)
                            .font(.headline)                        }
                     
                    }
                }
                .onDelete(perform: viewModel.deleteWord)
            }
            .navigationTitle("単語メモ")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddView = true
                    }) {
                        Image(systemName: "plus")
                        Spacer()
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
