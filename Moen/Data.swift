//
//  Data.swift
//  Moen
//
//  Created by Abdulelah Alshalhoub on 01/08/2018.
//  Copyright © 2018 ETAR. All rights reserved.
//

// Report Data class
class ReportData {
    
    var id: String!
    var type: String!
    var description: String!
    var latitude: Double!
    var longitude: Double!
    var altitude: Double!
    
    init(_ id: String, _ type: String, _ description: String, _ latitude: Double, _ longitude: Double, _ altitude: Double) {
        self.id = id
        self.type = type
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
    }
    
}
