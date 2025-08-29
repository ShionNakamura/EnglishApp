import SwiftUI

struct ProfileSetupView: View {
    @EnvironmentObject var authViewModel: AuthViewModel 
    @State private var username: String = ""
    @State private var gender: String = "未設定"
    @State private var birthDate = Date()
    
    @State private var isShowingConfirmation = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // ユーザー名
                    VStack(alignment: .leading, spacing: 8) {
                        Text("ユーザー名")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        TextField("ユーザー名を入力", text: $username)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                    }
                    
                    // 性別
                    VStack(alignment: .leading, spacing: 8) {
                        Text("性別")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Picker("性別を選択", selection: $gender) {
                            Text("男").tag("男")
                            Text("女").tag("女")
                            Text("未設定").tag("未設定")
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    // 誕生日
                    VStack(alignment: .leading) {
                        Text("誕生日")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        DatePicker("生年月日を選択してください", selection: $birthDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    // 確認画面に進むボタン
                    Spacer()
                    Button(action: {
                            authViewModel.username = username
                           authViewModel.gender = gender
                           authViewModel.birthDate = birthDate
                           isShowingConfirmation = true
                    }) {
                        Text("内容を確認して進む")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("アカウント設定")
            .navigationDestination(isPresented: $isShowingConfirmation) {
                ConfirmationView()
            }
        }
    }
}

#Preview {
    ProfileSetupView()
}

