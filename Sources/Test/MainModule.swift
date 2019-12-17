//
//  MainModule.swift
//  Test
//
//  Created by Samuel Cornejo on 12/11/19.
//

import Foundation

struct Reading {
    let value: Float
}

struct OtherData {
    let data: String
}

class MainModule {
    private(set) var identifier: String
    private(set) var reading: Reading
    private(set) var otherData: OtherData
    
    init?(identifier: String,
          reading: Reading = Reading(value: 0),
          otherData: OtherData = OtherData(data: "")) {
        guard !identifier.isEmpty else { return nil }
        self.identifier = identifier
        self.reading = reading
        self.otherData = otherData
    }
    
    func updateSensorReadings(newReading: Reading) {
        reading = newReading
    }
    
    func updateOtherData(newOtherData: OtherData) {
        otherData = newOtherData
    }
}
