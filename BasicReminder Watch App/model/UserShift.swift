//
//  UserShift.swift
//  BasicReminder Watch App
//
//  Created by Timothy Andrian on 26/05/24.
//

import SwiftData
import SwiftUI
import UserNotifications

@Model
final class UserShift {
    var isAfternoon: Bool
    
    init(isAfternoon: Bool) {
        self.isAfternoon = isAfternoon
    }
    
    func getClockInRemainingTime() -> Int {
        var timeToClockIn = 0
        if isAfternoon {
            timeToClockIn = 51300 - ((Calendar.current.component(.hour, from: Date.now)) * 3600 + Calendar.current.component(.minute, from: Date.now) * 60 + Calendar.current.component(.second, from: Date.now))
        } else {
            timeToClockIn = 33300 - ((Calendar.current.component(.hour, from: Date.now)) * 3600 + Calendar.current.component(.minute, from: Date.now) * 60 + Calendar.current.component(.second, from: Date.now))
        }
        return timeToClockIn
    }
    
    func getClockOutRemainingTime() -> Int {
        var timeToClockOut = 0
        if isAfternoon {
            timeToClockOut = 64800 - ((Calendar.current.component(.hour, from: Date.now)) * 3600 + Calendar.current.component(.minute, from: Date.now) * 60 + Calendar.current.component(.second, from: Date.now))
        } else {
            timeToClockOut = 46800 - ((Calendar.current.component(.hour, from: Date.now)) * 3600 + Calendar.current.component(.minute, from: Date.now) * 60 + Calendar.current.component(.second, from: Date.now))
        }
        return timeToClockOut
    }
    
    func getClockInTime() -> Date {
        var clockInTimeComponent = DateComponents()
        if isAfternoon {
            clockInTimeComponent.hour = 14
            clockInTimeComponent.minute = 15
        } else {
            clockInTimeComponent.hour = 09
            clockInTimeComponent.minute = 15
        }
        
        let clockInTime = Calendar.current.date(from: clockInTimeComponent) ?? .now
        return clockInTime
    }
    
    func getClockOutTime() -> Date {
        var clockOutTimeComponent = DateComponents()
        if isAfternoon {
            clockOutTimeComponent.hour = 18
            clockOutTimeComponent.minute = 0
        } else {
            clockOutTimeComponent.hour = 13
            clockOutTimeComponent.minute = 0
        }
        
        let clockOutTime = Calendar.current.date(from: clockOutTimeComponent) ?? .now
        return clockOutTime
    }
    
    func scheduleClockInNotifications() {
        
        let content = UNMutableNotificationContent()
        content.title = "CLOCK IN!!"
        content.sound = .defaultCritical
        content.categoryIdentifier = "myCategory"

        let category = UNNotificationCategory(identifier: "myCategory", actions: [], intentIdentifiers: [], options: [])
        for minute in 0..<16 {
            if isAfternoon {
                let components = DateComponents(hour: 14, minute: minute)
                UNUserNotificationCenter.current().setNotificationCategories([category])
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                let request = UNNotificationRequest(identifier: "clockIn_\(minute)", content: content, trigger: trigger)

                UNUserNotificationCenter.current().add(request) { (error) in
                    if let error = error {
                        print("Error scheduling notification: \(error)")
                    } else {
                        print("Scheduled notification for minute \(minute) past 14 AM")
                    }
                }
            } else {
                let components = DateComponents(hour: 9, minute: minute)
                UNUserNotificationCenter.current().setNotificationCategories([category])
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                let request = UNNotificationRequest(identifier: "clockIn_\(minute)", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { (error) in
                    if let error = error {
                        print("Error scheduling notification: \(error)")
                    } else {
                        print("Scheduled notification for minute \(minute) past 9 AM")
                    }
                }
            }
        }
    }
    
    func scheduleClockOutNotifications() {
        let content = UNMutableNotificationContent()
        content.title = "CLOCK OUT!!"
        content.sound = .defaultCritical
        content.categoryIdentifier = "myCategory"
        let category = UNNotificationCategory(identifier: "myCategory", actions: [], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        if isAfternoon {
            let components = DateComponents(hour: 13, minute: 00)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let request = UNNotificationRequest(identifier: "clockOut", content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                } else {
                    print("Scheduled notification for minute past 18 PM")
                }
            }
        } else {
            let components = DateComponents(hour: 18, minute: 00)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let request = UNNotificationRequest(identifier: "clockOut", content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                } else {
                    print("Scheduled notification for minute past 13 PM")
                }
            }
        }
    }
    
    func scheduleImmedieateNotification() {
        let content = UNMutableNotificationContent()
        content.title = "CLOCK IN!!"
        content.sound = .defaultCritical
        content.categoryIdentifier = "myCategory"
        let category = UNNotificationCategory(identifier: "myCategory", actions: [], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "clockOut", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Scheduled immedieate notification!")
            }
        }
    }
    
    func requestAuthorizationForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (success, error) in
            if success{
                print("All set")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

