import SwiftUI

struct ReviewTypingQuizView: View {
    @ObservedObject var viewModel: WordViewModel

    @State private var questionList: [WordEntity] = []
    @State private var currentIndex = 0
    @State private var userAnswer = ""
    @State private var isAnswered = false
    @State private var isCorrect = false
    @State private var correctCount = 0
    @State private var wrongCount = 0
    @State private var isFinished = false
    @AppStorage("currentScreen") private var currentScreen = "starter"

    var body: some View {
        VStack(spacing: 20) {
            if isFinished {
                // 🔹 結果画面
                Text("お疲れさまでした！")
                    .font(.largeTitle)
                Text("正解: \(correctCount) 問 / 不正解: \(wrongCount) 問")
                    .font(.title2)
                    .padding()

                HStack {
                    Button("もう一度復習する") {
                        restartQuiz()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

        
                }

            } else if !questionList.isEmpty {
                let word = questionList[currentIndex]

                // 🔹 進捗表示
                Text("問題 \(currentIndex + 1) / \(questionList.count)")
                    .font(.headline)

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
                        loadNextQuestion()
                    }
                    .padding(.top)
                } else {
                    Button(action: {
                        checkAnswer()
                    }, label: {
                        Text("答えを見る")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 180, height: 50)
                            .background(.blue)
                            .cornerRadius(10)
                    })
                    .padding(.top)
                }

                // 🔹 正解数・不正解数
                HStack {
                    Text("✅ 正解: \(correctCount)")
                        .foregroundColor(.green)
                    Text("❌ 不正解: \(wrongCount)")
                        .foregroundColor(.red)
                }
                .font(.headline)
                .padding(.top, 30)

            } else {
                Text("単語が登録されていません。")
            }
        }
        .padding()
        .onAppear {
            setupQuiz()
        }
    }

    // MARK: - クイズの初期化
    func setupQuiz() {
        questionList = viewModel.words.shuffled() // ランダム順に並び替え
        currentIndex = 0
        correctCount = 0
        wrongCount = 0
        isFinished = false
        resetAnswerState()
    }

    func restartQuiz() {
        setupQuiz()
    }

    // MARK: - 答えチェック
    func checkAnswer() {
        guard let correctWord = questionList[currentIndex].word?.lowercased() else { return }
        isCorrect = (userAnswer.lowercased() == correctWord)
        if isCorrect {
            correctCount += 1
        } else {
            wrongCount += 1
        }
        isAnswered = true
    }

    // MARK: - 次の問題へ
    func loadNextQuestion() {
        if currentIndex + 1 < questionList.count {
            currentIndex += 1
            resetAnswerState()
        } else {
            isFinished = true
        }
    }

    func resetAnswerState() {
        isAnswered = false
        userAnswer = ""
        isCorrect = false
    }
}

#Preview {
    let context = PersistenceController.shared.container.viewContext
    let viewModel = WordViewModel(context: context)
    return ReviewTypingQuizView(viewModel: viewModel)
}

