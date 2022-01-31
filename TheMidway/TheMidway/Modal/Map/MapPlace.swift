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
    var pin: MKPointAnnotation?
    var type: PlacesCategories
    let addressInfo: AddressInfo
}
