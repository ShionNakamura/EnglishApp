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

//      @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate　　// これがcrushする原因

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(AuthViewModel())
                .onAppear {
                                   NotificationManager.shared.requestAuthorization()
                                   NotificationManager.shared.scheduleDailyNotification()
                               }
        }
    }
}
