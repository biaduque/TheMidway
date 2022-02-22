//
//  LocationManegerDelegate.swift
//  TheMidway
//
//  Created by Gui Reis on 26/01/22.
//

import UIKit
import CoreLocation

class LocationManegerDelegate: NSObject, CLLocationManagerDelegate {
    
    /* MARK: - Atributos */
    
    private var mapManeger: MapViewManeger?
    
    
    
    /* MARK: - Encapsulamento */
    
    public func setManeger(manegar: MapViewManeger) -> Void {
        self.mapManeger = manegar
    }
    
    
    
    /* MARK: - Delegate (MapView) */

    /// Autorização pra usar o mapa
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            if let maneger = self.mapManeger?.locationManager {
                maneger.startUpdatingLocation()
            }
        }
    }
    
    
    
    
}
