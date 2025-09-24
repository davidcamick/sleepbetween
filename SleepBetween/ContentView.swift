import SwiftUI

struct ContentView: View {
    @EnvironmentObject var alarmManager: AlarmManager
    @State private var selectedTime = Date()
    @State private var showTimePicker = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                
                // Header
                VStack(spacing: 10) {
                    Text("SleepBetween")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Set your wake-up time")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Current alarm display
                VStack(spacing: 20) {
                    if let wakeUpTime = alarmManager.wakeUpTime {
                        VStack(spacing: 15) {
                            Text("Wake up at")
                                .font(.title2)
                                .foregroundColor(.secondary)
                            
                            Text(wakeUpTime, style: .time)
                                .font(.system(size: 48, weight: .light, design: .rounded))
                                .foregroundColor(.primary)
                            
                            if alarmManager.isAlarmActive {
                                HStack {
                                    Image(systemName: "bell.fill")
                                        .foregroundColor(.green)
                                    Text("Alarm is active")
                                        .foregroundColor(.green)
                                        .fontWeight(.medium)
                                }
                            }
                        }
                        .padding(.vertical, 30)
                        .padding(.horizontal, 40)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                        )
                    } else {
                        VStack(spacing: 15) {
                            Image(systemName: "moon.zzz")
                                .font(.system(size: 60))
                                .foregroundColor(.secondary)
                            
                            Text("No alarm set")
                                .font(.title2)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 40)
                        .padding(.horizontal, 40)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                        )
                    }
                }
                
                Spacer()
                
                // Action buttons
                VStack(spacing: 15) {
                    Button(action: {
                        showTimePicker = true
                    }) {
                        HStack {
                            Image(systemName: "clock")
                            Text("Set Wake-Up Time")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.blue)
                        )
                    }
                    
                    if alarmManager.wakeUpTime != nil {
                        Button(action: {
                            alarmManager.cancelAlarm()
                        }) {
                            HStack {
                                Image(systemName: "xmark.circle")
                                Text("Cancel Alarm")
                            }
                            .font(.headline)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.red, lineWidth: 2)
                            )
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showTimePicker) {
            TimePickerView(selectedTime: $selectedTime) {
                alarmManager.setAlarm(for: selectedTime)
                showTimePicker = false
            }
        }
    }
}

struct TimePickerView: View {
    @Binding var selectedTime: Date
    let onConfirm: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Select wake-up time")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
                
                DatePicker(
                    "Wake-up time",
                    selection: $selectedTime,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding()
                
                Spacer()
            }
            .navigationTitle("Set Alarm")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Set") {
                        onConfirm()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AlarmManager())
}