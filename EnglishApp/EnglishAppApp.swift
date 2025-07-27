
import SwiftUI

@main
struct EnglishAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                                   NotificationManager.shared.requestAuthorization()
                                   NotificationManager.shared.scheduleDailyNotification()
                               }
        }
    }
}
