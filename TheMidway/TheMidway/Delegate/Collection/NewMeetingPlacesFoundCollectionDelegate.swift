//
//  NewMeetingPlacesFoundCollectionDelegate.swift
//  TheMidway
//
//  Created by Gui Reis on 27/01/22.
//

import UIKit

class NewMeetingPlacesFoundCollectionDelegate: NSObject, UICollectionViewDelegate {

    /* MARK: - Atributos */
    
    private var mapManeger: MapViewManeger!
    
    private var placesFound: [MapPlace] = []
    
    
    
    /* MARK: - Encapsulamento */
    
    public func setMapManeger(_ maneger: MapViewManeger) -> Void {
        return self.mapManeger = maneger
    }
    
    public func setPlacesFound(_ places: [MapPlace]) -> Void {
        return self.placesFound = places
    }

    
    
    /* MARK: - Delegate */
    
    /// Ação de quando clica em uma célula
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) -> Void {
        
        self.mapManeger.setMapFocus(at: self.placesFound[indexPath.row].coordinates, radius: 250)
    }
}
