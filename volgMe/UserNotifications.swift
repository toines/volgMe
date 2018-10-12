//
//  UserNotifications.swift
//  volgMe
//
//  Created by Toine Schnabel on 11/10/2018.
//  Copyright © 2018 Toine Schnabel. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

extension LogBoekVC {
    func  vraagToestemmingVoorNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in})
    }
    
    func stuurNotification(title:String,body:String,badge:NSNumber){
        notes = notes + [body]
        var x = ""
        for note in notes {
            x = x + note + "\r"
        }
        let content = UNMutableNotificationContent()
        content.body = x
        content.title = title
 //       content.subtitle = "---"
        content.badge = badge
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 30, repeats: false)
        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        if notes.count == 4 {notes.remove(at: 0)}
    }
}
