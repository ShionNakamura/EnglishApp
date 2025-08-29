import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var user: User? = Auth.auth().currentUser
    @Published var isLoading = false
    @Published var isNewUser: Bool = false
    
    @Published var username: String = ""
    @Published var gender: String = "未設定"
    @Published var birthDate: Date = Date()
    
    @Published var tempEmail: String = ""
    @Published var tempPassword: String = ""
    // MARK: - ログイン
    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let result = authResult {
                    self?.user = result.user
                    self?.isNewUser = result.additionalUserInfo?.isNewUser ?? false
                }
                completion(.success(()))
            }
        }
    }
    
    // MARK: - サインアップ
    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let result = authResult {
                    self?.user = result.user
                    self?.isNewUser = result.additionalUserInfo?.isNewUser ?? true
                }
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Firestoreにプロフィール保存
    func saveProfileToFirestore(completion: @escaping (Error?) -> Void) {
        guard let user = user else { return }
        let db = Firestore.firestore()
        let age = Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year ?? 0
        
        let data: [String: Any] = [
            "username": username,
            "gender": gender,
            "birthDate": Timestamp(date: birthDate),
            "age": age,
            "createdAt": Timestamp()
        ]
        
        db.collection("users").document(user.uid).setData(data, completion: completion)
    }
    
    // MARK: - ログアウト
    func logout() {
        do {
            try Auth.auth().signOut()
            user = nil
            username = ""
            gender = "未設定"
            birthDate = Date()
            isNewUser = false
        } catch {
            print("ログアウトエラー: \(error.localizedDescription)")
        }
    }
    
    // MARK: - パスワードリセット
    func sendPasswordReset(email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: completion)
    }
}

