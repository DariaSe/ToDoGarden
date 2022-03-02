//
//  NotificationService.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 28.02.2022.
//

import SwiftUI

class NotificationService: NSObject, UNUserNotificationCenterDelegate {
    
    static let shared : NotificationService = NotificationService()
    let notificationCenter = UNUserNotificationCenter.current()
    
    private override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    func scheduleNotifications(for tasks: [Task]) {
        var date = Date()
        var count = 1
        var ids: [Int] = []
        while count < 20 {
            for task in tasks {
                if task.appearsOnDate(date) && task.notificationDate != nil {
                    ids.append(task.id)
                    count += 1
                }
            }
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        }
        for task in tasks {
            let tasksToScheduleCount = ids.filter({$0 == task.id}).count
            if tasksToScheduleCount != 0 {
//                scheduleNotifications(for: task, count: tasksToScheduleCount)
            }
        }
    }
    
    func notificationContent(title: String, notificationDate: Date) -> UNMutableNotificationContent {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        let timeString = formatter.string(from: notificationDate)
        let content = UNMutableNotificationContent()
        content.title = timeString + " " + title
        return content
    }
    
    func scheduleNotifications(for task: Task, count: Int) {
        guard let notificationDate = task.notificationDate else { return }
        var date = Date()
        for i in 0..<count {
            let nextOccurenceDate = task.nextOccurenceDate(from: date)
            let calendar = Calendar.current
            var components = calendar.dateComponents([.day, .month, .year], from: nextOccurenceDate)
            components.hour = calendar.component(.hour, from: notificationDate)
            components.minute = calendar.component(.minute, from: notificationDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let identifier = task.id.description + i.description
            let content = notificationContent(title: task.title, notificationDate: notificationDate)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    // handle error here
                    print(error.localizedDescription)
                }
            }
            date = nextOccurenceDate
        }
    }
}

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    static let shared : NotificationManager = NotificationManager()
    let notificationCenter = UNUserNotificationCenter.current()
    
    private override init() {
        super.init()
        requestNotification()
        notificationCenter.delegate = self
        getnotifications()
    }
    
    func requestNotification() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if let error = error {
                // Handle the error here.
                print(error)
            }
            
            // Enable or disable features based on the authorization.
        }
    }
    /// Uses [.day, .hour, .minute, .second] in current timeZone
    func scheduleCalendarNotification(title: String, body: String, date: Date, repeats: Bool = false, identifier: String) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        let calendar = NSCalendar.current
        
        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            if error != nil {
                print(error!)
            }
        }
    }
    ///Sets up multiple calendar notification based on a date
    func recurringNotification(title: String, body: String, date: Date, identifier: String, everyXDays: Int, count: Int) {
        print(#function)
        for n in 0..<count{
            print(n)
            let newDate = date.addingTimeInterval(TimeInterval(60*60*24*everyXDays*n))
            //Idenfier must be unique so I added the n
            scheduleCalendarNotification(title: title, body: body, date: newDate, identifier: identifier + n.description)
            print(newDate)
        }
    }
    ///Prints to console schduled notifications
    func getnotifications(){
        notificationCenter.getPendingNotificationRequests { request in
            for req in request{
                if req.trigger is UNCalendarNotificationTrigger{
                    print((req.trigger as! UNCalendarNotificationTrigger).nextTriggerDate()?.description ?? "invalid next trigger date")
                }
            }
        }
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        
//        completionHandler(.banner)
//    }
}
