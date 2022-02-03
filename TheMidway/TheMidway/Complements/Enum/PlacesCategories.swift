//
//  PlacesCategories.swift
//  TheMidway
//
//  Created by Gui Reis on 24/01/22.
//


enum PlacesCategories: CustomStringConvertible {
    case amusementPark
    case nationalPark
    case restaurant
    case bakery
    case cafe
    case nightlife
    case theater
    case movieTheater
    case person
    case shopping

    /// Tags
    var localizedDescription:String {
        switch self {
            case .amusementPark, .nationalPark: return "Parque"
            case .restaurant: return "Restaurante"
            case .bakery: return "Padaria"
            case .theater, .movieTheater: return "Teatro"
            case .cafe: return "Cafeteria"
            case .nightlife: return "Bar"
            case .shopping: return "Shopping"
            case .person: return ""
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
            case .shopping: return ""
            case .person: return ""
        }
    }
}
