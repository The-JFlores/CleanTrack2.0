//
//  Building.swift
//  CleanTrack2
//
//  Created by Jose Flores on 2026-01-09.
//

import Foundation

struct Building: Identifiable, Hashable {
    let id: String
    let name: String
    let alarmCode: String
    let address: String
    let contact: String
    let latitude: Double
    let longitude: Double

    init(id: String = UUID().uuidString,
         name: String,
         alarmCode: String,
         address: String,
         contact: String,
         latitude: Double = 0.0,
         longitude: Double = 0.0) {
        self.id = id
        self.name = name
        self.alarmCode = alarmCode
        self.address = address
        self.contact = contact
        self.latitude = latitude
        self.longitude = longitude
    }

    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "alarmCode": alarmCode,
            "address": address,
            "contact": contact,
            "latitude": latitude,
            "longitude": longitude
        ]
    }

    init?(from dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let name = dictionary["name"] as? String,
              let alarmCode = dictionary["alarmCode"] as? String,
              let address = dictionary["address"] as? String,
              let contact = dictionary["contact"] as? String,
              let latitude = dictionary["latitude"] as? Double,
              let longitude = dictionary["longitude"] as? Double else {
            return nil
        }
        self.id = id
        self.name = name
        self.alarmCode = alarmCode
        self.address = address
        self.contact = contact
        self.latitude = latitude
        self.longitude = longitude
    }
}
