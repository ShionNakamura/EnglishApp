//
//
//import SwiftUI
//import FirebaseAuth
//
//struct LoginView: View {
//    @EnvironmentObject var authViewModel: AuthViewModel;@State private var email = ""
//@State private var password = ""
//@State private var errorMessage = ""
//@State private var isLoggedIn = false
//@State private var isSignUp = false
//
//var body: some View {
//    NavigationStack {
//        VStack(spacing: 20) {
//            Text("ログイン")
//                .font(.largeTitle)
//                .bold()
//
//            TextField("Email", text: $email)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .keyboardType(.emailAddress)
//                .autocapitalization(.none)
//                .padding(.horizontal)
//
//            SecureField("Password", text: $password)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding(.horizontal)
//
//            Button("ログイン") {
//                authViewModel.login(email: email, password: password) { result in
//                    switch result {
//                    case .success:
//                        isLoggedIn = true
//                    case .failure(let error):
//                        errorMessage = error.localizedDescription
//                    }
//                }
//            }
//            .padding()
//            .frame(maxWidth: .infinity)
//            .background(Color.blue)
//            .foregroundColor(.white)
//            .cornerRadius(8)
//            .padding(.horizontal)
//
//            Button("登録する") {
//                isSignUp = true
//            }
//            .padding()
//            .frame(maxWidth: .infinity)
//            .background(Color.green)
//            .foregroundColor(.white)
//            .cornerRadius(8)
//            .padding(.horizontal)
//
//            if !errorMessage.isEmpty {
//                Text(errorMessage)
//                    .foregroundColor(.red)
//                    .multilineTextAlignment(.center)
//                    .padding()
//            }
//        }
//        .padding()
////        .navigationDestination(isPresented: $isLoggedIn) {
//////            StarterView()
////
////        }
//
//    }
////}}#Preview {
////    LoginView()
////        .environmentObject(AuthViewModel())
////}
