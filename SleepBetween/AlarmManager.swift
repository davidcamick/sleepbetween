import Foundation
import UserNotifications
import ActivityKit

class AlarmManager: ObservableObject {
    @Published var wakeUpTime: Date?
    @Published var isAlarmActive: Bool = false
    
    @available(iOS 16.1, *)
    private var currentActivity: Activity<WakeUpActivityAttributes>?
    
    init() {
        checkForExistingAlarms()
    }
    
    func setAlarm(for time: Date) {
        // Cancel any existing alarm
        cancelAlarm()
        
        // Set new alarm
        wakeUpTime = time
        isAlarmActive = true
        
        // Schedule local notification
        scheduleNotification(for: time)
        
        // Start Live Activity
        startLiveActivity(for: time)
        
        print("Alarm set for \(time)")
    }
    
    func cancelAlarm() {
        // Cancel notification
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Stop Live Activity
        stopLiveActivity()
        
        // Reset state
        wakeUpTime = nil
        isAlarmActive = false
        
        print("Alarm cancelled")
    }
    
    private func scheduleNotification(for time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Wake Up!"
        content.body = "Time to wake up and start your day"
        content.sound = .default
        content.categoryIdentifier = "ALARM_CATEGORY"
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "WAKE_UP_ALARM",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
    
    private func startLiveActivity(for wakeUpTime: Date) {
        if #available(iOS 16.1, *) {
            guard ActivityAuthorizationInfo().areActivitiesEnabled else {
                print("Live Activities are not enabled")
                return
            }
            
            let attributes = WakeUpActivityAttributes(wakeUpTime: wakeUpTime)
            let state = WakeUpActivityAttributes.ContentState(
                timeRemaining: timeUntilWakeUp(from: wakeUpTime)
            )
            
            do {
                let activity = try Activity<WakeUpActivityAttributes>.request(
                    attributes: attributes,
                    contentState: state,
                    pushType: nil
                )
                
                currentActivity = activity
                
                // Update the activity periodically
                startActivityUpdates()
                
                print("Live Activity started")
            } catch {
                print("Error starting Live Activity: \(error)")
            }
        } else {
            print("Live Activities not available on this iOS version")
        }
    }
    
    private func stopLiveActivity() {
        if #available(iOS 16.1, *) {
            guard let activity = currentActivity else { return }
            
            Task {
                await activity.end(dismissalPolicy: .immediate)
                DispatchQueue.main.async {
                    self.currentActivity = nil
                }
            }
        }
    }
    
    private func startActivityUpdates() {
        if #available(iOS 16.1, *) {
            Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] timer in
                guard let self = self,
                      let activity = self.currentActivity,
                      let wakeUpTime = self.wakeUpTime else {
                    timer.invalidate()
                    return
                }
                
                let timeRemaining = self.timeUntilWakeUp(from: wakeUpTime)
                
                if timeRemaining <= 0 {
                    // Wake up time reached
                    timer.invalidate()
                    Task {
                        await activity.end(dismissalPolicy: .after(.seconds(30)))
                        DispatchQueue.main.async {
                            self.currentActivity = nil
                            self.isAlarmActive = false
                        }
                    }
                    return
                }
                
                let updatedState = WakeUpActivityAttributes.ContentState(
                    timeRemaining: timeRemaining
                )
                
                Task {
                    await activity.update(using: updatedState)
                }
            }
        }
    }
    
    private func timeUntilWakeUp(from wakeUpTime: Date) -> TimeInterval {
        let now = Date()
        let calendar = Calendar.current
        
        // If the wake up time is today and hasn't passed yet, use today
        if calendar.isDate(wakeUpTime, inSameDayAs: now) && wakeUpTime > now {
            return wakeUpTime.timeIntervalSince(now)
        }
        
        // Otherwise, schedule for tomorrow
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: now)!
        let wakeUpComponents = calendar.dateComponents([.hour, .minute], from: wakeUpTime)
        let tomorrowWakeUp = calendar.date(bySettingHour: wakeUpComponents.hour ?? 0,
                                          minute: wakeUpComponents.minute ?? 0,
                                          second: 0, of: tomorrow)!
        
        return tomorrowWakeUp.timeIntervalSince(now)
    }
    
    private func checkForExistingAlarms() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                self.isAlarmActive = !requests.isEmpty
                
                // Try to extract wake up time from existing notifications
                if let alarmRequest = requests.first(where: { $0.identifier == "WAKE_UP_ALARM" }),
                   let trigger = alarmRequest.trigger as? UNCalendarNotificationTrigger,
                   let nextTriggerDate = trigger.nextTriggerDate() {
                    self.wakeUpTime = nextTriggerDate
                }
            }
        }
    }
}