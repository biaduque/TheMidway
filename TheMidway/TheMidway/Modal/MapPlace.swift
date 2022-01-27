//
//  MapPlace.swift
//  TheMidway
//
//  Created by Gui Reis on 24/01/22.
//

import MapKit
import CoreLocation


struct MapPlace {
    let name: String
    let coordinates: CLLocationCoordinate2D
    let pin: MKPointAnnotation?
    var type: PlacesCategories
    
    let postalCode: String
    let country: String
    let city: String
    let district: String
    let address: String
    let number: String
}

/*
let address: String  -
let city: String  -
let country: String  -
let latitude: Float -
let longitude: Float -
let name: String -
let number: String -
let district: String  -
let type: String

let date: String
let hour: String
let meetingName: String
let participants: [String]
*/
