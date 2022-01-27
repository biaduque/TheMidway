//
//  MainCollectionDataSource.swift
//  TheMidway
//
//  Created by Gui Reis on 27/01/22.
//

import UIKit

class MainCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    /* MARK: - Atributos */
    
    static let sugestionTypes: [String] = ["Restaurante", "Bar", "Cafeteria", "Cinema", "Padaria", "Shopping", "Teatro"]
    
    
    
    /* MARK: - Data Sources */
    
    /// Mostra quantas células vão ser mostradas
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MainCollectionDataSource.sugestionTypes.count
    }
    
    
    /// Configura uma célula
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Cria uma variácel para mexer com uma célula que foi criada
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainViewCollectionCell.identifier, for: indexPath) as? MainViewCollectionCell else {
            return UICollectionViewCell()
        }
        
        cell.setContentView(text: MainCollectionDataSource.sugestionTypes[indexPath.row], sizeFont: 20, w: .medium)
        cell.tag = indexPath.row
        
        return cell
    }
}
