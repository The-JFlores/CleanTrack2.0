//
//  LocationManager.swift
//  CleanTrack2
//
//  Created by Jose Flores on 2026-01-16.
//
import Foundation
import CoreLocation
import UserNotifications

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestPermissions()
        configureNotification()
    }
    
    // Request location permissions (Always needed for geofencing)
    func requestPermissions() {
        locationManager.requestAlwaysAuthorization()
    }
    
    // Start monitoring a geofence region (add one per saved location)
    func startMonitoring(building: Building) {
        let coordinate = CLLocationCoordinate2D(latitude: building.latitude, longitude: building.longitude)
        let region = CLCircularRegion(center: coordinate, radius: 100, identifier: building.id) // 100 meters radius
        region.notifyOnEntry = true
        region.notifyOnExit = false
        
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            locationManager.startMonitoring(for: region)
        }
    }
    
    // Stop monitoring a geofence region
    func stopMonitoring(building: Building) {
        for region in locationManager.monitoredRegions {
            if let circularRegion = region as? CLCircularRegion,
               circularRegion.identifier == building.id {
                locationManager.stopMonitoring(for: circularRegion)
            }
        }
    }
    
    // CLLocationManagerDelegate - Authorization status changed
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        if authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            // Handle denied or restricted cases here
            print("Location permission not granted or limited")
        }
    }
    
    // CLLocationManagerDelegate - Handle entering geofence region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            sendNotification(title: "Near a building", body: "You are near \(region.identifier)")
        }
    }
    
    // Send local notification when near a building
    func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: nil)  // deliver immediately
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error.localizedDescription)")
            }
        }
    }
    
    // Configure notification permissions
    private func configureNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
}
