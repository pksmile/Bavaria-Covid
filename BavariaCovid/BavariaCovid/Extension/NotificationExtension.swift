//
//  NotificationExtension.swift
//  BavariaCovid
//
//  Created by PRAKASH on 12/20/20.
//

import UserNotifications
import UIKit

extension UNUserNotificationCenter {
    class func sendCovideAlertMsg(title: String, message: String) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = .default
        let  trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.2,repeats: false)
        let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
        center.add(request) { (error) in
            if error != nil {
                print("Error = \(error?.localizedDescription ?? "error local notification")")
            }
        }
    }
}

