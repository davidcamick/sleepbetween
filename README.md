# SleepBetween

A clean, modern Swift iOS app that helps you set wake-up times with live countdown activities and native iPhone alarms.

## Features

- ✨ **Modern SwiftUI Interface**: Clean, intuitive design with material effects
- ⏰ **Wake-up Time Setting**: Easy-to-use time picker for setting your wake-up time
- 🔔 **Native iOS Alarms**: Uses iOS local notifications for reliable wake-up alarms
- 📱 **Live Activities**: Real-time countdown display on your lock screen and Dynamic Island
- 🌙 **Midnight Handling**: Automatically handles wake-up times for the next day
- 🎨 **Adaptive UI**: Supports both light and dark mode with beautiful accent colors

## Requirements

- iOS 16.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later

### For Live Activities
- iOS 16.1 or later
- iPhone 14 Pro or later (for Dynamic Island features)

## Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/davidcamick/sleepbetween.git
cd sleepbetween
```

### 2. Open in Xcode
```bash
open SleepBetween.xcodeproj
```

### 3. Configure Development Team
1. Select the project in Xcode navigator
2. Under "Signing & Capabilities", select your development team
3. Ensure the bundle identifier is unique (e.g., `com.yourname.sleepbetween`)

### 4. Add Required Capabilities
The project requires the following capabilities:
- **Push Notifications**: For alarm functionality
- **Live Activities**: For lock screen countdown display

To add these:
1. Select your target in Xcode
2. Go to "Signing & Capabilities" tab
3. Click "+" and add:
   - "Push Notifications"
   - "Live Activities" (iOS 16.1+)

### 5. Build and Run
1. Select your target device or simulator
2. Press Cmd+R or click the play button
3. Grant notification permissions when prompted

## How to Use

### Setting an Alarm
1. Launch the SleepBetween app
2. Tap "Set Wake-Up Time"
3. Choose your desired wake-up time using the wheel picker
4. Tap "Set" to confirm

### Live Activities
Once you set an alarm, you'll see:
- **Lock Screen**: A live countdown widget showing time remaining
- **Dynamic Island** (iPhone 14 Pro+): Compact countdown display
- **Expanded Dynamic Island**: Detailed wake-up information

### Managing Alarms
- **Cancel**: Tap "Cancel Alarm" to remove the current alarm
- **Modify**: Set a new time to replace the existing alarm
- **Auto-cleanup**: Alarms automatically clean up after the wake-up time

## App Architecture

### Core Components

- **`SleepBetweenApp.swift`**: Main app entry point with notification permissions
- **`ContentView.swift`**: Primary user interface with SwiftUI
- **`AlarmManager.swift`**: Core logic for alarm management and Live Activities
- **`WakeUpActivityAttributes.swift`**: Live Activities configuration and data structures

### Key Features Implementation

#### Alarm Management
```swift
class AlarmManager: ObservableObject {
    @Published var wakeUpTime: Date?
    @Published var isAlarmActive: Bool = false
    
    func setAlarm(for time: Date)
    func cancelAlarm()
}
```

#### Live Activities
- Automatic countdown updates every minute
- Progress bar showing time elapsed
- Color changes when wake-up time is near (5 minutes)
- Graceful fallback for older iOS versions

#### Smart Time Handling
- Automatically schedules for next day if time has passed
- Calculates time remaining accurately
- Handles midnight transitions properly

## Permissions

The app requests the following permissions:
- **Notifications**: Required for wake-up alarms
- **Live Activities**: Optional, for lock screen countdown display

## Troubleshooting

### Notifications Not Working
1. Check Settings > Notifications > SleepBetween
2. Ensure "Allow Notifications" is enabled
3. Verify "Sounds" and "Alerts" are enabled

### Live Activities Not Showing
1. Ensure you're running iOS 16.1 or later
2. Check Settings > Face ID & Passcode > Live Activities (enabled)
3. For Dynamic Island: Requires iPhone 14 Pro or later

### Build Issues
1. Ensure your development team is set correctly
2. Verify bundle identifier is unique
3. Check that required capabilities are added
4. Try cleaning build folder (Cmd+Shift+K)

## Customization

### Changing Colors
Modify the accent color in `Assets.xcassets/AccentColor.colorset/Contents.json`:
```json
"components" : {
  "alpha" : "1.000",
  "blue" : "1.000",
  "green" : "0.584",
  "red" : "0.000"
}
```

### Updating Live Activity Design
Edit the `WakeUpActivityAttributes.swift` file to customize:
- Countdown display format
- Progress bar appearance
- Dynamic Island layout
- Color schemes

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on device (not just simulator for Live Activities)
5. Submit a pull request

## License

This project is open source. Feel free to use it as a starting point for your own iOS alarm apps.

## Support

If you encounter any issues or have suggestions, please open an issue on GitHub.

---

**Note**: This app requires physical iOS device testing for full functionality, especially Live Activities and notification features which don't work fully in the iOS Simulator.
