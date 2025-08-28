import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct EnglishAppApp: App {
    let persistenceController = PersistenceController.shared

      @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authViewModel = AuthViewModel()   

    var body: some Scene {
        WindowGroup {
            if authViewModel.user != nil {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(authViewModel)
                    .onAppear {
                        NotificationManager.shared.requestAuthorization()
                        NotificationManager.shared.scheduleDailyNotification()
                    }
            } else {
                LoginView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
