//
//  SuggestionsCollectionDataSource.swift
//  TheMidway
//
//  Created by Gui Reis on 03/02/22.
//

import UIKit

class SuggestionsCollectionDataSource: NewMeetingPlacesFoundCollectionDataSource {
    
    /* MARK: - Atributos */
    
    private var suggestionsProtocol: SuggestionsControllerDelegate!
    
    
    
    /* MARK: - Encapsulamento */
    
    public func setProtocol(_ delegate: SuggestionsControllerDelegate) -> Void {
        self.suggestionsProtocol = delegate
    }
    
    
    
    /* MARK: - Delegate */
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.suggestionsProtocol.getSuggestionsPlaces().count
    }
    
    /// Configura uma célula
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Cria uma variável para mexer com uma célula que foi criada
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestionsCollectionCell.identifier, for: indexPath) as? SuggestionsCollectionCell else {
            return UICollectionViewCell()
        }
        
        let allPlaces = self.suggestionsProtocol.getSuggestionsPlaces()
        
        let completeAddress = NewMeetingViewController.creatAddressVisualization(place: allPlaces[indexPath.row].addressInfo)
        
        cell.setCellInfo(
            title: LabelConfig(text: allPlaces[indexPath.row].name, sizeFont: 20, weight: .bold),
            address: LabelConfig(text: completeAddress, sizeFont: 15, weight: .regular),
            tag: allPlaces[indexPath.row].type
        )
        
        // Botão web
        let webButton = cell.getWebButton()
        webButton.tag = indexPath.row
        
        self.suggestionsProtocol.setWebButtonAction(webButton)
        
        // Sombra
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.6
        cell.layer.shadowOffset = .zero
        cell.layer.shadowRadius = 5
        
        return cell
    }
}
