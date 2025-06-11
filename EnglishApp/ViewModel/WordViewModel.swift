

import Foundation


class WordViewModel: ObservableObject {
    @Published var words: [WordItem] = []

    func addWord(word: String, meaning: String, example: String) {
        let newItem = WordItem(word: word, meaning: meaning, example: example)
        words.insert(newItem, at: 0)
    }

    func deleteWord(at offsets: IndexSet) {
        words.remove(atOffsets: offsets)
    }
}
