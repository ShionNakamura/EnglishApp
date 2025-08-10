import Foundation
import CoreData

class WordViewModel: ObservableObject {
    let context: NSManagedObjectContext

    @Published var words: [WordEntity] = []

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchWords()
    }

    func fetchWords() {
        let request = NSFetchRequest<WordEntity>(entityName: "WordEntity")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \WordEntity.date, ascending: false)]

        do {
            words = try context.fetch(request)
        } catch {
            print("Fetch failed: \(error.localizedDescription)")
        }
    }

    func addWord(word: String, meaning: String, example: String) {
        let newWord = WordEntity(context: context)
        newWord.word = word
        newWord.meaning = meaning
        newWord.example = example
        newWord.date = Date()

        save()
    }

    func deleteWord(at offsets: IndexSet) {
        offsets.map { words[$0] }.forEach(context.delete)
        save()
    }

    private func save() {
        do {
            try context.save()
            fetchWords()
        } catch {
            print("Save failed: \(error.localizedDescription)")
        }
    }
}

