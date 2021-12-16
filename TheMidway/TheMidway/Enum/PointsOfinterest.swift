//
//  PointsOfinterests.swift
//  TheMidway
//
//  Created by Gui Reis on 16/12/21.
//

import Foundation
import MapKit

enum PointsOfInterest: CustomStringConvertible {
    case amusementPark
    case nationalPark
    case restaurant
    case bakery
    case cafe
    case nightlife
    case theater
    case movieTheater

    /// Tags
    var localizedDescription:String {
        switch self {
            case .amusementPark, .nationalPark: return "Parque"
            case .restaurant: return "Restaurante"
            case .bakery: return "Padaria"
            case .theater, .movieTheater: return "Teatro"
            case .cafe: return "Café"
            case .nightlife: return "Bar"
        }
    }

    /// MKPointOfInterest
    var description:String {
        switch self {
            case .amusementPark: return "MKPOICategoryAmusementPark"
            case .nationalPark: return "MKPOICategoryPark"
            case .restaurant: return "MKPOICategoryRestaurant"
            case .bakery: return "MKPOICategoryBakery"
            case .theater: return "MKPOICategoryTheater"
            case .movieTheater: return "MKPOICategoryMovietheater"
            case .cafe: return "MKPOICategoryCafe"
            case .nightlife: return "MKPOICategoryNightlife"
        }
    }
}
