//
//  AppDelegate.swift
//  CleanTrack2
//
//  Created by Jose Flores on 2026-01-16.
//

import UIKit
import Firebase
import UserNotifications
import CoreLocation

class AppDelegate: NSObject, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    
    let locationManager = CLLocationManager()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()

        // Request permission for notifications
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            }
        }

        // Request permission for location
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()

        return true
    }
    
    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        // Trigger notification when entering the region
        sendNotification(for: region.identifier)
    }

    func sendNotification(for regionId: String) {
        let content = UNMutableNotificationContent()
        content.title = "You are near a saved location"
        content.body = "You just entered the region: \(regionId)"
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(identifier: "regionNotification", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
    
    // Optional: show notifications when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
            willPresent notification: UNNotification,
            withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
