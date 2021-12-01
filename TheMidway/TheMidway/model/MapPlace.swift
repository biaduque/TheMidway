//
//  MapPlace.swift
//  Aula MapKit
//
//  Created by Gui Reis on 24/11/21.
//

import Foundation
import CoreLocation
import MapKit


struct MapPlace {
    let name: String
    let coordinates: CLLocationCoordinate2D
    let address: CLLocation
    let pin: MKPointAnnotation
    let type: MKPointOfInterestCategory
}
