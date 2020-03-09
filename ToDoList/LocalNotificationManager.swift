//
//  LocalNotificationManager.swift
//  ToDoList
//
//  Created by Harrison Fish on 3/9/20.
//  Copyright © 2020 Harrison Fish. All rights reserved.
//

import UIKit
import UserNotifications

struct LocalNotificationManager {
    
    static func authorizeLocalNotifications(viewController: UIViewController) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                return
            }
            if granted {
                print("Granted")
            } else {
                print("Not Granted")
                DispatchQueue.main.async {
                    viewController.oneButtonAlert(title: "User Has Not Allowed Notifications", message: "Please allow notifications for access to this feature.")
                }
                
            }
        }
    }
    
    static func isAuthorized(completed: @escaping (Bool) -> ()) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                completed(false)
                return
            }
            if granted {
                print("Granted")
                completed(true)
            } else {
                print("Not Granted")
                completed(false)
            }
        }
    }
    
    static func setCalendarNotifications(title: String, subtitle: String, body: String, badgeNumber: NSNumber?, sound: UNNotificationSound, date: Date) -> String {
        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = sound
        content.body = body
        content.sound = sound
        content.badge = badgeNumber
        
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        dateComponents.second = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let notificationID = UUID().uuidString
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            } else {
                print("\(notificationID)")
            }
        }
        return notificationID
    }
}
