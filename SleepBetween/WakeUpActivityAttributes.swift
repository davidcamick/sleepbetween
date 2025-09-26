import ActivityKit
import Foundation

@available(iOS 16.1, *)
struct WakeUpActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var timeRemaining: TimeInterval
        
        var formattedTimeRemaining: String {
            let hours = Int(timeRemaining) / 3600
            let minutes = Int(timeRemaining % 3600) / 60
            
            if hours > 0 {
                return "\(hours)h \(minutes)m"
            } else {
                return "\(minutes)m"
            }
        }
        
        var isAlmostTime: Bool {
            return timeRemaining <= 300 // 5 minutes
        }
    }
    
    var wakeUpTime: Date
}