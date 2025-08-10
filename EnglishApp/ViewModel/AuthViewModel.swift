import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var user: User? = Auth.auth().currentUser
    @Published var isLoading = false
    
    // ログイン
    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                self?.user = authResult?.user
                completion(.success(()))
            }
        }
    }
    
    // 新規登録
    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                self?.user = authResult?.user
                completion(.success(()))
            }
        }
    }
    
    // ログアウト
    func logout() throws {
        try Auth.auth().signOut()
        user = nil
    }
    
    // パスワードリセット
    func sendPasswordReset(email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: completion)
    }
}

