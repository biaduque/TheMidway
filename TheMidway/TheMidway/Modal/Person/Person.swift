//
//  Person.swift
//  TheMidway
//
//  Created by Gui Reis on 24/01/22.
//

import struct CoreLocation.CLLocationCoordinate2D


struct Person {
    let contactInfo: ContactInfo
    let image: Int
    let coordinate: CLLocationCoordinate2D
    var meetingId: Int
}
