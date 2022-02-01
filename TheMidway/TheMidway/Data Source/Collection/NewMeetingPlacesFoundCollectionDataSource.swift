//
//  NewMeetingPlacesFoundCollectionDataSource.swift
//  TheMidway
//
//  Created by Gui Reis on 27/01/22.
//

import UIKit

class NewMeetingPlacesFoundCollectionDataSource: NSObject, UICollectionViewDataSource {

    /* MARK: - Atributos */
    
    private var placesFound: [MapPlace] = []
    
    
    
    /* MARK: - Encapsulamento */
    
    public func setPlacesFound(_ places: [MapPlace]) -> Void {
        return self.placesFound = places
    }
    
    
    
    /* MARK: - Delegate */
    
    /// Mostra quantas células vão ser mostradas
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.placesFound.count
    }
    
    
    /// Configura uma célula
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Cria uma variável para mexer com uma célula que foi criada
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewMeetingCollectionCell.identifier, for: indexPath) as? NewMeetingCollectionCell else {
            return UICollectionViewCell()
        }
        
        let completeAddress = NewMeetingViewController.creatAddressVisualization(place: self.placesFound[indexPath.row].addressInfo)
        
        cell.setCellInfo(
            title: LabelConfig(text: self.placesFound[indexPath.row].name, sizeFont: 20, weight: .bold),
            address: LabelConfig(text: completeAddress, sizeFont: 15, weight: .regular),
            tag: self.placesFound[indexPath.row].type
        )
        
        // Sombra
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.6
        cell.layer.shadowOffset = .zero
        cell.layer.shadowRadius = 5
        
        return cell
    }
}
