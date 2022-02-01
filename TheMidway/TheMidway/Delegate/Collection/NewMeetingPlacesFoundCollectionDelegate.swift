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
    
    private var lastCellChecked = NewMeetingCollectionCell()
    
    
    
    /* MARK: - Encapsulamento */
    
    public func setMapManeger(_ maneger: MapViewManeger) -> Void {
        return self.mapManeger = maneger
    }
    
    public func setPlacesFound(_ places: [MapPlace]) -> Void {
        return self.placesFound = places
    }
    
    public func getCellChecked() -> NewMeetingCollectionCell {
        return self.lastCellChecked
    }
    
    
    
    /* MARK: - Delegate */
    
    /// Ação de quando clica em uma célula
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) -> Void {
        // Pega a célula clicada
        guard let cell = collectionView.cellForItem(at: indexPath) as? NewMeetingCollectionCell else {
            return
        }
        
        if self.lastCellChecked == cell {
            if !self.lastCellChecked.checkedToggle() {
                collectionView.tag = -1
                return
            }
        } else {
            cell.checkCell()
            self.lastCellChecked.uncheckCell()
            self.lastCellChecked = cell
        }
        
        collectionView.tag = indexPath.row
        
        self.mapManeger.setMapFocus(at: self.placesFound[indexPath.row].coordinates, radius: 2000)
    }
}
