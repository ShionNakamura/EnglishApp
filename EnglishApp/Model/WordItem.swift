

import Foundation

struct WordItem: Identifiable {
    let id = UUID()
    var word: String
    var meaning: String
    var example: String
    var date: Date = Date()
}
