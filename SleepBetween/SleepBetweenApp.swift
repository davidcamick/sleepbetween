import SwiftUI
import UserNotifications

@main
struct SleepBetweenApp: App {
    @StateObject private var alarmManager = AlarmManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(alarmManager)
                .onAppear {
                    requestNotificationPermissions()
                }
        }
    }
    
    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permissions granted")
            } else if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
}