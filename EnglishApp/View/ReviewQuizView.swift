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

    var body: some View {
        VStack(spacing: 20) {
            if isFinished {
           
                VStack(spacing: 20) {
                    Spacer()
                    Text("🎉 お疲れさまでした！")
                        .font(.largeTitle)
                        .bold()
                    
                    Text("正解: \(correctCount) / 不正解: \(wrongCount)")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    
                    Button("もう一度復習する") {
                        restartQuiz()
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    Spacer()
                }
                .transition(.opacity.combined(with: .scale))
            } else if !questionList.isEmpty {
                let word = questionList[currentIndex]
                Spacer()
                
                Text("\(currentIndex + 1) / \(questionList.count)")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
           
                // 進捗バー
                
                ProgressView(value: Double(currentIndex + 1), total: Double(questionList.count))
                    .accentColor(.blue)
                    .padding(.horizontal)
                
                // クイズカード
                VStack(spacing: 20) {
                    Text("意味: \(word.meaning ?? "")")
                        .font(.title2)
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                    
                    TextField("単語を入力してください", text: $userAnswer)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    if isAnswered {
                        Text(isCorrect ? "正解！🎉" : "不正解…😢 答えは『\(word.word ?? "")』")
                            .foregroundColor(isCorrect ? .green : .red)
                            .font(.title3)
                            .bold()
                            .transition(.scale)
                        
                        Button("次の問題へ") {
                            loadNextQuestion()
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    } else {
                        Button("答えを見る") {
                            checkAnswer()
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 20).fill(.ultraThinMaterial))
                .shadow(radius: 5)
                
                // 正解数・不正解数
                HStack(spacing: 20) {
                    Label("\(correctCount)", systemImage: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.headline)
                    Label("\(wrongCount)", systemImage: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.headline)
                }
            } else {
                Text("単語が登録されていません。")
                    .foregroundColor(.secondary)
                    .font(.title3)
            }
            
            Spacer()
        }
        .padding()
        .onAppear { setupQuiz() }
        .animation(.default, value: currentIndex)
    }

    // MARK: - Quiz Logic
    func setupQuiz() {
        questionList = viewModel.words.shuffled()
        currentIndex = 0
        correctCount = 0
        wrongCount = 0
        isFinished = false
        resetAnswerState()
    }
    
    func restartQuiz() { setupQuiz() }
    
    func checkAnswer() {
        guard let correctWord = questionList[currentIndex].word?.lowercased() else { return }
        isCorrect = userAnswer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == correctWord
        if isCorrect { correctCount += 1 } else { wrongCount += 1 }
        isAnswered = true
    }
    
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

