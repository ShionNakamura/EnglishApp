

import SwiftUI

struct AddWordView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: WordViewModel

    @State private var word = ""
    @State private var meaning = ""
    @State private var example = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("単語: Apple", text: $word)
                TextField("意味: リンゴ", text: $meaning)
                TextField("例: I ate an apple today", text: $example)
            }
            .navigationTitle("新しい単語")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        if !word.isEmpty && !meaning.isEmpty && !example.isEmpty {
                            viewModel.addWord(word: word, meaning: meaning, example: example)
                            dismiss()
                        }
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
            }
        }
    }
}



#Preview {
//    AddWordView(viewModel: WordViewModel())
    let context = PersistenceController.shared.container.viewContext
       return AddWordView(viewModel: WordViewModel(context: context))
}
