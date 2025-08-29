import SwiftUI

struct AccountView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text("ユーザー名: \(authViewModel.username)")
            Text("性別: \(authViewModel.gender)")
            Text("誕生日: \(authViewModel.birthDate.formatted(date: .long, time: .omitted))")
            Text("メール: \(authViewModel.user?.email ?? "")")
            
            Spacer()
            
            Button(action: {
                authViewModel.logout()
            }) {
                Text("ログアウト")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(12)
            }
        }
        .padding()
        .navigationTitle("アカウント")
    }
}

#Preview{
    AccountView()
}
