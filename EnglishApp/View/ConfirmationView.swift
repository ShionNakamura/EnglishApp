import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ConfirmationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isLoading = false
    @State private var errorMessage = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                CardView(title: "メールアドレス", content: authViewModel.tempEmail)
                CardView(title: "パスワード", content: String(repeating: "*", count: authViewModel.tempPassword.count))
                CardView(title: "ユーザー名", content: authViewModel.username)
                CardView(title: "性別", content: authViewModel.gender)
                CardView(title: "誕生日", content: authViewModel.birthDate.formatted(date: .long, time: .omitted))

                Button(action: registerAccount) {
                    Text(isLoading ? "作成中..." : "アカウント作成")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isLoading ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(isLoading)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
        }
        .navigationTitle("確認")
    }

    private func registerAccount() {
        isLoading = true
        errorMessage = ""

        authViewModel.signUp(email: authViewModel.tempEmail, password: authViewModel.tempPassword) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success:
                    saveProfileToFirestore()
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    private func saveProfileToFirestore() {
        authViewModel.saveProfileToFirestore { error in
            if let error = error {
                errorMessage = "Firestore保存エラー: \(error.localizedDescription)"
            } else {
                print("プロフィール保存完了")
            }
        }
    }
}

struct CardView: View {
    let title: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(content)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
        }
    }
}

#Preview {
    ConfirmationView()
        .environmentObject(AuthViewModel())
}
