import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("通知許可されました")
            } else {
                print("通知拒否されました")
            }
        }
    }

    func scheduleDailyNotification(hour: Int = 21, minute: Int = 0) {
        let content = UNMutableNotificationContent()
        content.title = "英単語復習タイム 📚"
        content.body = "今日の単語をチェックしよう！"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: "dailyReviewNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyReviewNotification"]) // 重複防止
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("通知の登録に失敗: \(error.localizedDescription)")
            } else {
                print("通知が登録されました")
            }
        }
    }
}

