import SwiftUI

struct ReviewTypingQuizView: View {
    @ObservedObject var viewModel: WordViewModel

    @State private var currentWord: WordEntity?
    @State private var userAnswer = ""
    @State private var isAnswered = false
    @State private var isCorrect = false

    var body: some View {
        VStack(spacing: 20) {
            if let word = currentWord {
                Text("単語の意味: \(word.meaning ?? "")")
                    .font(.title2)
                    .padding()

                TextField("単語を入力", text: $userAnswer)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                if isAnswered {
                    Text(isCorrect ? "正解！🎉" : "不正解…😢 答えは『\(word.word ?? "")』")
                        .foregroundColor(isCorrect ? .green : .red)
                        .font(.title2)

                    Button("次の問題へ") {
                        loadNewQuestion()
                    }
                    .padding(.top)
                } else {

                    Button(action: {
                        checkAnswer()

                    }, label: {
                        Text("答えを見る")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 180,height: 50)
                            .background(.blue)
                            .cornerRadius(10)
                            
                            
                    })
                    .padding(.top)
                }
            } else {
                Text("単語が登録されていません。")
            }
        }
        .padding()
        .onAppear {
            loadNewQuestion()
        }
    }

    func checkAnswer() {
        guard let correctWord = currentWord?.word?.lowercased() else { return }
        isCorrect = (userAnswer.lowercased() == correctWord)
        isAnswered = true
    }

    func loadNewQuestion() {
        isAnswered = false
        userAnswer = ""
        isCorrect = false

        guard !viewModel.words.isEmpty else {
            currentWord = nil
            return
        }

        currentWord = viewModel.words.randomElement()
    }
}


#Preview {
    let context = PersistenceController.shared.container.viewContext
    let viewModel = WordViewModel(context: context)
    return ReviewTypingQuizView(viewModel: viewModel)
}
