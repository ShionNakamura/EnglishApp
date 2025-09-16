import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    @State private var isRegistered = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                
                Text("新規登録")
                    .font(.title)
                    .bold()
                    .frame(height: 100)
                
                // メール
                TextField("メールアドレス", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(.horizontal)
                
                // パスワード
                SecureField("パスワード", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                // 確認用パスワード
                SecureField("パスワード確認", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                // 登録ボタン
                Button("登録する") {
                    errorMessage = ""
                    
                    guard !email.isEmpty, !password.isEmpty else {
                        errorMessage = "メールとパスワードを入力してください"
                        return
                    }
                    
                    guard password == confirmPassword else {
                        errorMessage = "パスワードが一致しません"
                        return
                    }
                    
                    authViewModel.tempEmail = email
                    authViewModel.tempPassword = password
                    
                    authViewModel.signUp(email: email, password: password) { result in
                        switch result {
                        case .success:
                            isRegistered = true
                        case .failure(let error):
                            errorMessage = error.localizedDescription
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal)
                
                // エラー表示
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            // NavigationStack + navigationDestinationで遷移
            .navigationDestination(isPresented: $isRegistered) {
                ProfileSetupView()
                    .environmentObject(authViewModel)
            }
        }
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthViewModel())
}

