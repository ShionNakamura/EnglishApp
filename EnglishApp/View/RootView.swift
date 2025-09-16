import SwiftUI

struct RootView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        //fixed rootView
        Group {
            if let _ = authViewModel.user {
                if authViewModel.isNewUser {
                    ProfileSetupView()
                } else {
                    ContentView()
                }
            } else {
                LoginView()
            }
        }
    }
}


#Preview {
    let dummyAuthVM = AuthViewModel()
    RootView()
        .environmentObject(dummyAuthVM)
}

